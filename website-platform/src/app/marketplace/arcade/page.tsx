import TugLobbyClient from './TugLobbyClient';

export default function ArcadePage() {
  return (
    <div className="min-h-screen bg-[#0b0f19] text-white flex flex-col items-center justify-center p-6">
      <div className="max-w-4xl w-full">
        <TugLobbyClient />
      </div>
    </div>
  );
}
