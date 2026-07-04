import { getActiveSites } from './actions';
import SignupClient from './SignupClient';

export default async function DriverSignupPage() {
  const sites = await getActiveSites();

  return (
    <div className="min-h-screen bg-[#0b0f19] text-white flex items-center justify-center py-12 px-6">
      <div className="max-w-md w-full">
        <SignupClient sites={sites} />
      </div>
    </div>
  );
}
