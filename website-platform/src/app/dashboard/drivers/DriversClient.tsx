'use client';

import { useState } from 'react';
import { Truck, Mail, Phone, MapPin, User, Check, X, AlertCircle } from 'lucide-react';
import { updateDriverApplicationStatus } from './actions';

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

export default function DriversClient({ initialApplications }: { initialApplications: Application[] }) {
  const [apps, setApps] = useState<Application[]>(initialApplications);
  const [selectedApp, setSelectedApp] = useState<Application | null>(initialApplications[0] || null);

  const handleStatusChange = async (appId: string, newStatus: string) => {
    // Optimistic UI update
    setApps(apps.map(a => a.id === appId ? { ...a, status: newStatus } : a));
    if (selectedApp?.id === appId) {
      setSelectedApp({ ...selectedApp, status: newStatus });
    }

    const res = await updateDriverApplicationStatus(appId, newStatus);
    if (!res.success) {
      alert(res.error || 'Failed to update application status.');
    }
  };

  if (apps.length === 0) {
    return (
      <div className="border border-dashed border-border/50 rounded-2xl flex flex-col items-center justify-center text-center p-8 bg-secondary/5 min-h-[300px]">
        <Truck className="w-12 h-12 text-muted-foreground mb-4" />
        <h3 className="text-xl font-bold mb-2">No Applications Yet</h3>
        <p className="text-muted-foreground max-w-sm">
          When people apply to deliver for your store, their applications will show up here!
        </p>
      </div>
    );
  }

  return (
    <div className="h-[600px] flex border border-border/50 rounded-2xl overflow-hidden bg-background">
      {/* Sidebar: Applications List */}
      <div className="w-1/3 border-r border-border/50 flex flex-col bg-secondary/5">
        <div className="p-4 border-b border-border/50 bg-background/50">
          <h2 className="font-semibold">All Applicants ({apps.length})</h2>
        </div>
        <div className="flex-grow overflow-y-auto">
          {apps.map((app) => (
            <button
              key={app.id}
              onClick={() => setSelectedApp(app)}
              className={`w-full text-left p-4 border-b border-border/50 transition-colors flex items-start gap-3 ${
                selectedApp?.id === app.id ? 'bg-primary/5 border-l-4 border-l-primary' : 'hover:bg-secondary/20 border-l-4 border-l-transparent'
              }`}
            >
              <div className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center shrink-0">
                <User className="w-5 h-5 text-muted-foreground" />
              </div>
              <div className="flex-grow min-w-0">
                <div className="flex justify-between items-start mb-1">
                  <h4 className="font-bold truncate">{app.name}</h4>
                  <span className="text-xs text-muted-foreground shrink-0">
                    {new Date(app.created_at).toLocaleDateString()}
                  </span>
                </div>
                
                <div className="flex items-center gap-1 text-xs text-muted-foreground mb-2">
                  <Truck className="w-3.5 h-3.5" />
                  {app.vehicle_type}
                </div>

                <div className="flex items-center gap-2">
                  <span className={`text-[10px] uppercase font-bold tracking-wider px-2 py-0.5 rounded-full ${
                    app.status === 'Pending' ? 'bg-amber-500/10 text-amber-500' :
                    app.status === 'Approved' ? 'bg-green-500/10 text-green-500' :
                    'bg-rose-500/10 text-rose-500'
                  }`}>
                    {app.status}
                  </span>
                  <span className="text-xs text-muted-foreground truncate">
                    Store: {app.site.name}
                  </span>
                </div>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Main Content: Details */}
      <div className="flex-1 flex flex-col bg-background relative">
        {selectedApp ? (
          <div className="p-8 space-y-6 flex-grow overflow-y-auto">
            <div className="flex justify-between items-start border-b border-border/50 pb-6">
              <div>
                <h2 className="text-2xl font-bold mb-2">{selectedApp.name}</h2>
                <div className="flex flex-col gap-1 text-sm text-muted-foreground">
                  <div className="flex items-center gap-2">
                    <Mail className="w-4 h-4" />
                    <a href={`mailto:${selectedApp.email}`} className="text-primary hover:underline">{selectedApp.email}</a>
                  </div>
                  <div className="flex items-center gap-2">
                    <Phone className="w-4 h-4" />
                    <a href={`tel:${selectedApp.phone}`} className="text-primary hover:underline">{selectedApp.phone}</a>
                  </div>
                </div>
              </div>

              {selectedApp.status === 'Pending' ? (
                <div className="flex gap-2">
                  <button 
                    onClick={() => handleStatusChange(selectedApp.id, 'Rejected')}
                    className="px-4 py-2 border border-rose-500/20 text-rose-500 rounded-xl text-sm font-medium hover:bg-rose-500/5 transition-all flex items-center gap-1.5"
                  >
                    <X className="w-4 h-4" />
                    Reject
                  </button>
                  <button 
                    onClick={() => handleStatusChange(selectedApp.id, 'Approved')}
                    className="px-4 py-2 bg-primary text-white rounded-xl text-sm font-medium hover:bg-primary/90 transition-all flex items-center gap-1.5"
                  >
                    <Check className="w-4 h-4" />
                    Approve Driver
                  </button>
                </div>
              ) : (
                <div className="flex items-center gap-2">
                  <span className="text-sm text-muted-foreground">Application processed as</span>
                  <span className={`text-xs uppercase font-bold tracking-wider px-3 py-1 rounded-full ${
                    selectedApp.status === 'Approved' ? 'bg-green-500/10 text-green-500 border border-green-500/20' : 'bg-rose-500/10 text-rose-500 border border-rose-500/20'
                  }`}>
                    {selectedApp.status}
                  </span>
                  <button 
                    onClick={() => handleStatusChange(selectedApp.id, 'Pending')}
                    className="text-xs text-primary hover:underline ml-2"
                  >
                    Reset Status
                  </button>
                </div>
              )}
            </div>

            <div className="grid md:grid-cols-2 gap-6">
              <div className="bg-secondary/10 border border-border/50 rounded-2xl p-6 space-y-4">
                <h3 className="font-bold text-sm uppercase tracking-wider text-gray-400">Driver Credentials</h3>
                
                <div className="space-y-3">
                  <div>
                    <span className="text-xs text-muted-foreground block">Vehicle Type</span>
                    <span className="text-sm font-semibold flex items-center gap-2 mt-0.5">
                      <Truck className="w-4 h-4 text-primary" />
                      {selectedApp.vehicle_type}
                    </span>
                  </div>
                  
                  <div>
                    <span className="text-xs text-muted-foreground block">Applicant Location</span>
                    <span className="text-sm font-semibold flex items-center gap-2 mt-0.5">
                      <MapPin className="w-4 h-4 text-primary" />
                      {selectedApp.location}
                    </span>
                  </div>
                </div>
              </div>

              <div className="bg-secondary/10 border border-border/50 rounded-2xl p-6 space-y-4">
                <h3 className="font-bold text-sm uppercase tracking-wider text-gray-400">Store Selection</h3>
                
                <div className="space-y-3">
                  <div>
                    <span className="text-xs text-muted-foreground block">Requested Store</span>
                    <span className="text-sm font-semibold block mt-0.5">{selectedApp.site.name}</span>
                  </div>
                  
                  <div>
                    <span className="text-xs text-muted-foreground block">Store Address</span>
                    <span className="text-sm font-semibold flex items-center gap-2 mt-0.5">
                      <MapPin className="w-4 h-4 text-primary" />
                      {selectedApp.site.location}
                    </span>
                  </div>
                </div>
              </div>
            </div>
            
            <div className="bg-blue-500/10 border border-blue-500/20 rounded-2xl p-4 text-sm text-blue-500 flex items-start gap-3">
              <AlertCircle className="w-5 h-5 shrink-0 mt-0.5" />
              <div>
                <span className="font-bold">Important Onboarding Tip:</span>
                <p className="opacity-95 mt-0.5">After approving, you should email or call the applicant to schedule their vehicle inspection and coordinate delivery zones.</p>
              </div>
            </div>
          </div>
        ) : (
          <div className="h-full flex items-center justify-center text-muted-foreground">
            Select an applicant to view details
          </div>
        )}
      </div>
    </div>
  );
}
