'use server';

import { createClient } from '@/utils/supabase/server';

const LOBBY_ID = '00000000-0000-0000-0000-000000000000';

export async function getTugLobby() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('tug_lobbies')
    .select('*')
    .eq('id', LOBBY_ID)
    .single();

  if (error) {
    console.error('Error fetching tug lobby:', error);
    return null;
  }

  return data;
}

export async function pullRope(team: 'left' | 'right') {
  const supabase = await createClient();

  // Fetch current state
  const { data: lobby, error: fetchErr } = await supabase
    .from('tug_lobbies')
    .select('*')
    .eq('id', LOBBY_ID)
    .single();

  if (fetchErr || !lobby) {
    console.error('Error fetching lobby for pull:', fetchErr);
    return { success: false };
  }

  let position = lobby.position;
  let status = lobby.status;
  let teamLeftScore = lobby.team_left_score;
  let teamRightScore = lobby.team_right_score;

  // Handle auto-reset if game finished more than 4 seconds ago
  if (status !== 'active') {
    // We check if the database timestamp (or simulated timeout) has passed.
    // In our case, we can just reset it immediately on the next pull to keep things moving.
    position = 0;
    status = 'active';
  }

  // Update position
  if (team === 'left') {
    position -= 1;
  } else {
    position += 1;
  }

  // Check win conditions (at -25 or +25 for faster gameplay!)
  const WIN_THRESHOLD = 25;
  if (position <= -WIN_THRESHOLD) {
    status = 'left_won';
    teamLeftScore += 1;
    position = -WIN_THRESHOLD;
  } else if (position >= WIN_THRESHOLD) {
    status = 'right_won';
    teamRightScore += 1;
    position = WIN_THRESHOLD;
  }

  const { error: updateErr } = await supabase
    .from('tug_lobbies')
    .update({
      position,
      status,
      team_left_score: teamLeftScore,
      team_right_score: teamRightScore
    })
    .eq('id', LOBBY_ID);

  if (updateErr) {
    console.error('Error updating rope position:', updateErr);
    return { success: false };
  }

  return { 
    success: true, 
    lobby: { 
      id: LOBBY_ID, 
      position, 
      status, 
      team_left_score: teamLeftScore, 
      team_right_score: teamRightScore 
    } 
  };
}
