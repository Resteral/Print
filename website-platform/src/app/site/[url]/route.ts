import { createClient } from '@/utils/supabase/server';
import { NextRequest, NextResponse } from 'next/server';

export async function GET(
  request: NextRequest,
  { params }: { params: { url: string } }
) {
  const url = params.url;
  
  if (!url) {
    return new NextResponse('Missing URL parameter', { status: 400 });
  }

  const supabase = await createClient();

  // Find the site by URL
  const { data: site, error } = await supabase
    .from('sites')
    .select('id, user_id, html_content, status, is_verified_secure, is_verified_human_review')
    .eq('url', url)
    .single();

  if (error || !site) {
    return new NextResponse('Site not found', { status: 404 });
  }

  // If no html content exists (like for mock sites generated before Phase 5)
  if (!site.html_content) {
    const fallbackHtml = `
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Resolve.bet Site</title>
        <script src="https://cdn.tailwindcss.com"></script>
      </head>
      <body class="bg-gray-50 flex items-center justify-center min-h-screen font-sans">
        <div class="text-center p-8 max-w-lg bg-white shadow-xl rounded-2xl border border-gray-100">
          <div class="text-blue-500 mb-4 flex justify-center">
            <svg class="w-16 h-16 animate-bounce" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
          </div>
          <h1 class="text-2xl font-bold text-gray-900 mb-2">This site is being built</h1>
          <p class="text-gray-600 mb-6">Our AI builder is compiling page elements and styles. Please check back in a few seconds!</p>
        </div>
      </body>
      </html>
    `;
    return new NextResponse(fallbackHtml, { status: 200, headers: { 'Content-Type': 'text/html' } });
  }

  // Embed Live chat support widget iframe automatically (Phase 12)
  const embedCode = `
    <!-- Live Support Chat widget iframe -->
    <script>
      (function() {
        var container = document.createElement('div');
        container.style.position = 'fixed';
        container.style.bottom = '20px';
        container.style.right = '20px';
        container.style.zIndex = '99999';
        container.style.transition = 'all 0.3s ease';
        document.body.appendChild(container);

        var iframe = document.createElement('iframe');
        iframe.src = 'https://resolve.bet/support/embed?siteId=${site.id}';
        iframe.style.width = '65px';
        iframe.style.height = '65px';
        iframe.style.border = '0';
        iframe.style.background = 'transparent';
        iframe.style.transition = 'all 0.3s ease';
        container.appendChild(iframe);

        window.addEventListener('message', function(event) {
          if (event.data === 'open-support') {
            iframe.style.width = '330px';
            iframe.style.height = '430px';
          } else if (event.data === 'close-support') {
            iframe.style.width = '65px';
            iframe.style.height = '65px';
          }
        });
      })();
    </script>

    <!-- Powered by Resolve.bet Referral & Trust Badges -->
    <div style="position: fixed; bottom: 20px; left: 20px; z-index: 99999; display: flex; flex-direction: column; gap: 8px; font-family: sans-serif; align-items: flex-start; pointer-events: auto;">
      <a href="https://resolve.bet/signup?ref=${site.user_id}" target="_blank" style="background: rgba(15, 23, 42, 0.95); border: 1px solid rgba(255, 255, 255, 0.15); padding: 9px 12px; border-radius: 12px; font-size: 11px; font-weight: 600; color: #fff; text-decoration: none; display: flex; align-items: center; gap: 8px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.3); backdrop-filter: blur(8px); transition: transform 0.2s ease;" onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
        <span style="display: inline-block; width: 8px; height: 8px; background: #6366f1; border-radius: 50%;"></span>
        Powered by Resolve.bet
      </a>
      
      ${site.is_verified_secure ? `
      <div style="background: rgba(16, 185, 129, 0.95); border: 1px solid rgba(255, 255, 255, 0.1); padding: 7px 10px; border-radius: 8px; font-size: 9px; font-weight: 700; color: #fff; display: flex; align-items: center; gap: 6px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); text-transform: uppercase; letter-spacing: 0.5px; backdrop-filter: blur(8px);">
        <svg style="width: 12px; height: 12px;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path></svg>
        Verified Secure
      </div>
      ` : ''}

      ${site.is_verified_human_review ? `
      <div style="background: rgba(59, 130, 246, 0.95); border: 1px solid rgba(255, 255, 255, 0.1); padding: 7px 10px; border-radius: 8px; font-size: 9px; font-weight: 700; color: #fff; display: flex; align-items: center; gap: 6px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); text-transform: uppercase; letter-spacing: 0.5px; backdrop-filter: blur(8px);">
        <svg style="width: 12px; height: 12px;" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
        Human Verified Copy
      </div>
      ` : ''}
    </div>
  `;

  let finalHtml = site.html_content;
  if (finalHtml.includes('</body>')) {
    finalHtml = finalHtml.replace('</body>', `${embedCode}</body>`);
  } else {
    finalHtml += embedCode;
  }

  // Return the raw generated HTML
  return new NextResponse(finalHtml, {
    status: 200,
    headers: { 'Content-Type': 'text/html' },
  });
}
