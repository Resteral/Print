import { createClient } from '@/utils/supabase/server';
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const siteId = searchParams.get('site_id');

  if (!siteId) {
    return NextResponse.json({ error: 'Missing site_id' }, { status: 400 });
  }

  const supabase = await createClient();

  // Fetch pending driver applications for this site
  const { count: pendingDrivers, error: driverErr } = await supabase
    .from('driver_applications')
    .select('*', { count: 'exact', head: true })
    .eq('preferred_site_id', siteId)
    .eq('status', 'Pending');

  // Fetch new CRM leads for this site
  const { count: newLeads, error: crmErr } = await supabase
    .from('crm_leads')
    .select('*', { count: 'exact', head: true })
    .eq('site_id', siteId)
    .eq('status', 'New');

  if (driverErr || crmErr) {
    return NextResponse.json({ 
      error: 'Database query failed',
      details: { driverErr: driverErr?.message, crmErr: crmErr?.message }
    }, { status: 500 });
  }

  return NextResponse.json({
    pendingDrivers: pendingDrivers || 0,
    newLeads: newLeads || 0,
    hasAlert: (pendingDrivers || 0) > 0 || (newLeads || 0) > 0
  });
}
