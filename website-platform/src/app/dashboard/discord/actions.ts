'use server';

import { generateObject } from 'ai';
import { anthropic } from '@ai-sdk/anthropic';
import { z } from 'zod';

const discordServerSchema = z.object({
  serverName: z.string(),
  iconText: z.string().describe('1-3 letters shorthand for the server icon'),
  categories: z.array(z.object({
    name: z.string().describe('e.g. INFORMATION, CHAT CHANNELS, MATCH LOBBIES'),
    channels: z.array(z.object({
      name: z.string().describe('e.g. announcements, general-chat, lobby-1'),
      type: z.enum(['text', 'voice']),
      description: z.string().describe('A brief description of what this channel is for')
    }))
  })),
  roles: z.array(z.object({
    name: z.string().describe('e.g. Owner, Moderator, VIP, Player'),
    color: z.string().describe('Hex color code, e.g. #FF0000'),
    isStaff: z.boolean()
  })),
  welcomeMessage: z.string().describe('A welcome message that an AI bot could post in the general channel')
});

export type DiscordServerStructure = z.infer<typeof discordServerSchema>;

export async function generateDiscordServer(prompt: string) {
  try {
    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      // Mock fallback if no key
      return {
        success: true,
        data: getMockDiscordServer(prompt)
      };
    }

    const { object } = await generateObject({
      model: anthropic('claude-3-5-sonnet-latest'),
      schema: discordServerSchema,
      prompt: `Create a Discord server structure optimized for: ${prompt}.
Make it feel professional, highly structured, and custom-tailored to the niche. Include relevant categories (like welcome, info, lobby rooms, staff), channel descriptions, roles with fitting names/colors, and a cool welcome message.`
    });

    return { success: true, data: object };
  } catch (error) {
    console.error('Error generating Discord server:', error);
    const err = error as Error;
    return { success: false, error: err.message };
  }
}

function getMockDiscordServer(prompt: string): DiscordServerStructure {
  return {
    serverName: `${prompt} Community`,
    iconText: prompt.substring(0, 2).toUpperCase(),
    categories: [
      {
        name: 'WELCOME & RULES',
        channels: [
          { name: 'welcome', type: 'text', description: 'New members land here' },
          { name: 'rules', type: 'text', description: 'Community guidelines' }
        ]
      },
      {
        name: 'COMMUNITY CHAT',
        channels: [
          { name: 'general', type: 'text', description: 'General chat' },
          { name: 'memes', type: 'text', description: 'Post funny gaming memes' }
        ]
      },
      {
        name: 'LOBBY ROOMS',
        channels: [
          { name: 'Lobby 1', type: 'voice', description: 'Voice chat for Tug Matches' },
          { name: 'Lobby 2', type: 'voice', description: 'Matchmaking chat' }
        ]
      }
    ],
    roles: [
      { name: 'Owner', color: '#ff0055', isStaff: true },
      { name: 'Moderator', color: '#3b82f6', isStaff: true },
      { name: 'MVP Player', color: '#10b981', isStaff: false },
      { name: 'Member', color: '#9ca3af', isStaff: false }
    ],
    welcomeMessage: `Welcome to the ${prompt} Discord server! Please read the rules and introduce yourself in the general chat!`
  };
}
