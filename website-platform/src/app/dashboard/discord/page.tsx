import DiscordClient from './DiscordClient';

export default function DiscordGeneratorPage() {
  return (
    <div className="p-8 max-w-6xl mx-auto h-[calc(100vh-2rem)] flex flex-col">
      <header className="mb-6 shrink-0">
        <h1 className="text-3xl font-bold mb-2">AI Discord Server Generator</h1>
        <p className="text-muted-foreground text-sm">Describe your community, and the AI will craft a custom Discord server blueprint and show a live interactive preview.</p>
      </header>
      
      <div className="flex-grow overflow-hidden relative rounded-2xl border border-border/50 bg-[#313338]">
        <DiscordClient />
      </div>
    </div>
  );
}
