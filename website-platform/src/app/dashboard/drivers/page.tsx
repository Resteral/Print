import { createClient } from '@/utils/supabase/server';
import DriversClient from './DriversClient';

interface Application {
  id: string;
  name: string;
  email: string;
  phone: string;
  vehicle_type: string;
  location: string;
  status: string;
  created_at: string;
  site: {
    name: string;
    location: string;
  };
}

export default async function MerchantDriversPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  // Fetch sites owned by user
  const { data: sites } = await supabase
    .from('sites')
    .select('id, name')
    .eq('user_id', user?.id || '');

  let applications: Application[] = [];
  if (sites && sites.length > 0) {
    const siteIds = sites.map(s => s.id);
    
    // Fetch applications submitted to these sites
    const { data: apps, error } = await supabase
      .from('driver_applications')
      .select(`
        *,
        site:sites (
          name,
          location
        )
      `)
      .in('preferred_site_id', siteIds)
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Error fetching driver applications:', error);
    } else if (apps) {
      applications = apps;
    }
  }

  return (
    <div className="p-8 max-w-6xl mx-auto">
      <header className="mb-10">
        <h1 className="text-3xl font-bold mb-2">Delivery Drivers</h1>
        <p className="text-muted-foreground text-sm">Review and manage driver applications submitted for your stores.</p>
      </header>

      {sites && sites.length > 0 ? (
        <DriversClient initialApplications={applications} />
      ) : (
        <div className="text-center p-12 border border-dashed border-border/50 rounded-2xl bg-secondary/5 text-muted-foreground">
          You need to generate a website before you can onboard delivery drivers!
        </div>
      )}
    </div>
  );
}
