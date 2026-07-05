'use server';

import { createClient } from '@/utils/supabase/server';
import { revalidatePath } from 'next/cache';

export async function updateCustomDomain(siteId: string, domain: string) {
  const supabase = await createClient();
  
  // Basic validation
  if (!domain.includes('.')) {
    return { success: false, error: 'Invalid domain format' };
  }

  // Check if domain is already taken
  const { data: existing } = await supabase
    .from('sites')
    .select('id')
    .eq('custom_domain', domain)
    .single();
    
  if (existing && existing.id !== siteId) {
    return { success: false, error: 'Domain is already connected to another site' };
  }

  const { error } = await supabase
    .from('sites')
    .update({ custom_domain: domain })
    .eq('id', siteId);
    
  if (error) {
    return { success: false, error: error.message };
  }
  
  revalidatePath('/dashboard/sites');
  return { success: true };
}

export async function toggleVerificationFlags(siteId: string, flag: 'secure' | 'human', value: boolean) {
  const supabase = await createClient();
  
  const payload = flag === 'secure' 
    ? { is_verified_secure: value }
    : { is_verified_human_review: value };

  const { error } = await supabase
    .from('sites')
    .update(payload)
    .eq('id', siteId);
    
  if (error) {
    return { success: false, error: error.message };
  }
  
  revalidatePath('/dashboard/sites');
  return { success: true };
}
