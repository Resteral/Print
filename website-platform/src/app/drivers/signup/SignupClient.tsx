'use client';

import { useState } from 'react';
import { submitDriverApplication } from './actions';
import { MapPin, Truck, Mail, Phone, User, CheckCircle2, ArrowLeft } from 'lucide-react';
import Link from 'next/link';

interface Site {
  id: string;
  name: string;
  location: string;
}

export default function SignupClient({ sites }: { sites: Site[] }) {
  const [submitted, setSubmitted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [vehicleType, setVehicleType] = useState('Car');
  const [location, setLocation] = useState('');
  const [preferredSiteId, setPreferredSiteId] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    const formData = new FormData();
    formData.append('name', name);
    formData.append('email', email);
    formData.append('phone', phone);
    formData.append('vehicleType', vehicleType);
    formData.append('location', location);
    formData.append('preferredSiteId', preferredSiteId);

    const res = await submitDriverApplication(formData);
    if (!res.success) {
      setError(res.error || 'Failed to submit application.');
      setLoading(false);
      return;
    }

    setSubmitted(true);
    setLoading(false);
  };

  if (submitted) {
    return (
      <div className="bg-secondary/10 border border-border/50 rounded-3xl p-8 text-center space-y-6 shadow-2xl">
        <div className="w-16 h-16 bg-[#23a55a]/10 border border-[#23a55a]/25 text-[#23a55a] rounded-full flex items-center justify-center mx-auto">
          <CheckCircle2 className="w-8 h-8" />
        </div>
        <div>
          <h2 className="text-2xl font-bold">Application Received!</h2>
          <p className="text-gray-400 text-sm mt-2">
            Thanks for applying. The store owner will review your application and contact you directly via email or phone.
          </p>
        </div>
        <Link href="/" className="inline-block bg-primary text-white px-6 py-2.5 rounded-xl text-sm font-semibold hover:bg-primary/95 transition-colors">
          Return Home
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <Link href="/" className="inline-flex items-center gap-2 text-sm text-gray-400 hover:text-white mb-2 transition-colors">
        <ArrowLeft className="w-4 h-4" />
        Back to Home
      </Link>

      <div className="text-center">
        <div className="inline-flex items-center justify-center w-12 h-12 bg-primary/20 text-primary rounded-xl mb-4">
          <Truck className="w-6 h-6" />
        </div>
        <h1 className="text-3xl font-extrabold tracking-tight">Become a Delivery Driver</h1>
        <p className="text-gray-400 text-sm mt-1">Deliver for local merchants in your neighborhood.</p>
      </div>

      <form onSubmit={handleSubmit} className="bg-secondary/10 border border-border/50 rounded-3xl p-8 space-y-4 shadow-2xl">
        {error && (
          <div className="bg-rose-500/10 border border-rose-500/20 text-rose-500 text-sm px-4 py-3 rounded-xl">
            {error}
          </div>
        )}

        <div>
          <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Full Name</label>
          <div className="relative">
            <User className="w-4 h-4 text-gray-500 absolute left-4 top-1/2 -translate-y-1/2" />
            <input 
              type="text" 
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g. John Doe"
              className="w-full bg-[#121824] border border-border/50 rounded-xl pl-12 pr-4 py-3 text-sm focus:outline-none focus:border-primary transition-colors text-white placeholder:text-gray-600"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Email Address</label>
            <div className="relative">
              <Mail className="w-4 h-4 text-gray-500 absolute left-4 top-1/2 -translate-y-1/2" />
              <input 
                type="email" 
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="name@example.com"
                className="w-full bg-[#121824] border border-border/50 rounded-xl pl-12 pr-4 py-3 text-sm focus:outline-none focus:border-primary transition-colors text-white placeholder:text-gray-600"
              />
            </div>
          </div>
          
          <div>
            <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Phone Number</label>
            <div className="relative">
              <Phone className="w-4 h-4 text-gray-500 absolute left-4 top-1/2 -translate-y-1/2" />
              <input 
                type="tel" 
                required
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="(123) 456-7890"
                className="w-full bg-[#121824] border border-border/50 rounded-xl pl-12 pr-4 py-3 text-sm focus:outline-none focus:border-primary transition-colors text-white placeholder:text-gray-600"
              />
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Your Location</label>
            <div className="relative">
              <MapPin className="w-4 h-4 text-gray-500 absolute left-4 top-1/2 -translate-y-1/2" />
              <input 
                type="text" 
                required
                value={location}
                onChange={(e) => setLocation(e.target.value)}
                placeholder="e.g. Seattle, WA"
                className="w-full bg-[#121824] border border-border/50 rounded-xl pl-12 pr-4 py-3 text-sm focus:outline-none focus:border-primary transition-colors text-white placeholder:text-gray-600"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Vehicle Type</label>
            <select 
              value={vehicleType}
              onChange={(e) => setVehicleType(e.target.value)}
              className="w-full bg-[#121824] border border-border/50 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-primary transition-colors text-white"
            >
              <option value="Car">Car</option>
              <option value="Motorcycle">Motorcycle</option>
              <option value="Scooter">Scooter</option>
              <option value="Bicycle">Bicycle</option>
              <option value="Walk">Walking / On Foot</option>
            </select>
          </div>
        </div>

        <div>
          <label className="block text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Preferred Local Store</label>
          <select 
            value={preferredSiteId}
            onChange={(e) => setPreferredSiteId(e.target.value)}
            className="w-full bg-[#121824] border border-border/50 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-primary transition-colors text-white"
          >
            <option value="">Apply for general local marketplace delivery</option>
            {sites.map(site => (
              <option key={site.id} value={site.id}>
                {site.name} ({site.location})
              </option>
            ))}
          </select>
        </div>

        <button 
          type="submit" 
          disabled={loading}
          className="w-full bg-primary hover:bg-primary/95 text-white font-medium py-3 rounded-xl text-sm transition-all disabled:opacity-50 mt-4"
        >
          {loading ? 'Submitting Application...' : 'Apply as Driver'}
        </button>
      </form>
    </div>
  );
}
