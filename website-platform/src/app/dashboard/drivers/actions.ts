'use server';

import { createClient } from '@/utils/supabase/server';
import { revalidatePath } from 'next/cache';

export async function updateDriverApplicationStatus(applicationId: string, status: string) {
  const supabase = await createClient();
  
  const { error } = await supabase
    .from('driver_applications')
    .update({ status })
    .eq('id', applicationId);
    
  if (error) {
    console.error('Error updating driver status:', error);
    return { success: false, error: error.message };
  }
  
  revalidatePath('/dashboard/drivers');
  return { success: true };
}
