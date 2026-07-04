'use server';

import { createClient } from '@/utils/supabase/server';

export async function getActiveSites() {
  const supabase = await createClient();
  
  const { data: sites } = await supabase
    .from('sites')
    .select('id, name, location')
    .order('name');
    
  return sites || [];
}

export async function submitDriverApplication(formData: FormData) {
  const supabase = await createClient();
  
  const name = formData.get('name') as string;
  const email = formData.get('email') as string;
  const phone = formData.get('phone') as string;
  const vehicleType = formData.get('vehicleType') as string;
  const location = formData.get('location') as string;
  const preferredSiteId = formData.get('preferredSiteId') as string;

  if (!name || !email || !phone || !vehicleType || !location) {
    return { success: false, error: 'All fields are required.' };
  }

  const { error } = await supabase
    .from('driver_applications')
    .insert([
      {
        name,
        email,
        phone,
        vehicle_type: vehicleType,
        location,
        preferred_site_id: preferredSiteId || null
      }
    ]);

  if (error) {
    console.error('Error submitting driver application:', error);
    return { success: false, error: 'Failed to submit application. Please try again.' };
  }

  return { success: true };
}
