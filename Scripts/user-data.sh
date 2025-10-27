#!/bin/bash
yum update -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx

#  custom landing page

cat <<'EOF' | sudo tee /usr/share/nginx/html/index.html > /dev/null
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Chiranjibi — AWS Secure Infrastructure</title>
  <meta name="description" content="Production-Grade AWS secure infrastructure — VPC, EC2, IAM, NAT, Bastion, and portfolio." />

  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

  <style>
    :root{
      --accent:#CC5500;
      --accent-600:#a14400;
      --muted:#6b7280;
      --bg:#f6f7fb;
      --card:#ffffff;
      --glass: rgba(255,255,255,0.6);
      --radius:14px;
      --maxw:1100px;
      --shadow: 0 12px 40px rgba(11,20,40,0.08);
      font-family: "Inter", system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
    }

    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0;
      min-height:100%;
      background:linear-gradient(180deg, #fffaf5 0%, #fff8f2 40%, #f6f7fb 100%);
      display:flex;
      align-items:center;
      justify-content:center;
      padding:28px;
      color:#0b1320;
    }

    .wrap{
      width:100%;
      max-width:var(--maxw);
      background:linear-gradient(180deg, rgba(255,255,255,0.9), var(--card));
      border-radius:var(--radius);
      box-shadow:var(--shadow);
      padding:36px;
      display:grid;
      gap:28px;
      grid-template-columns: 1fr 420px;
      align-items:start;
    }

    @media (max-width:980px){
      .wrap{grid-template-columns: 1fr; padding:22px}
    }

    .hero{padding-right:10px;}
    .eyebrow{
      display:inline-block;
      background: linear-gradient(90deg, rgba(204,85,0,0.12), rgba(204,85,0,0.06));
      color:var(--accent-600);
      font-weight:600;
      padding:6px 10px;
      border-radius:999px;
      font-size:13px;
      letter-spacing:0.2px;
    }

    h1{
      font-size:30px;
      margin:14px 0 8px;
      line-height:1.05;
      letter-spacing:-0.4px;
      color: #0b1320;
    }
    p.lead{
      margin:0 0 16px;
      color:var(--muted);
      font-size:15px;
    }

    .badges{display:flex;gap:8px;flex-wrap:wrap}
    .badge{
      background:var(--accent);
      color:#fff;
      padding:8px 12px;
      border-radius:999px;
      font-weight:600;
      font-size:13px;
      box-shadow: 0 6px 18px rgba(204,85,0,0.15);
    }

    .cards{
      margin-top:18px;
      display:grid;
      grid-template-columns:repeat(2, minmax(0,1fr));
      gap:12px;
    }
    @media (max-width:640px){ .cards{grid-template-columns:1fr} }

    /* Enhanced 3D card effect */
    .card{
      background:var(--glass);
      border-radius:10px;
      padding:14px;
      border:1px solid rgba(11,20,40,0.04);
      backdrop-filter: blur(6px);
      box-shadow: 0 8px 18px rgba(0,0,0,0.06), 6px 6px 20px rgba(204,85,0,0.08);
      transform: translateY(0);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .card:hover{
      transform: translateY(-4px);
      box-shadow: 0 12px 24px rgba(0,0,0,0.1), 8px 8px 24px rgba(204,85,0,0.12);
    }

    .card h3{margin:0;font-size:15px;color:var(--accent-600)}
    .card p{margin:8px 0 0;color:var(--muted);font-size:13px}

    .aside{
      padding-left:6px;
      display:flex;
      flex-direction:column;
      gap:14px;
    }
    .status{
      background: linear-gradient(90deg, rgba(40,167,69,0.12), rgba(40,167,69,0.05));
      padding:12px;
      border-radius:10px;
      display:flex;
      align-items:center;
      gap:10px;
      border:1px solid rgba(11,20,40,0.04);
    }
    .status .dot{width:12px;height:12px;border-radius:999px;background:#28a745;box-shadow:0 6px 14px rgba(40,167,69,0.12)}
    .status strong{font-size:14px}
    .side-card{
      background:var(--card);
      padding:18px;
      border-radius:10px;
      border:1px solid rgba(11,20,40,0.04);
      box-shadow: 0 6px 16px rgba(11,20,40,0.05);
    }
    .side-card h4{margin:0 0 6px}
    .side-card p{margin:0;color:var(--muted);font-size:14px}

    .cta-row{display:flex;gap:12px;margin-top:14px;flex-wrap:wrap}
    .btn{
      border:0;padding:12px 16px;border-radius:10px;font-weight:700;cursor:pointer;font-size:14px;
      box-shadow:0 10px 24px rgba(11,20,40,0.06);
    }
    .btn-primary{
      background:var(--accent); color:white;
    }
    .btn-outline{
      background:transparent;color:var(--accent);border:1px solid rgba(204,85,0,0.14);
    }

    .features{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-top:6px}
    @media (max-width:720px){ .features{grid-template-columns:1fr} }

    .feature{display:flex;gap:10px;align-items:flex-start;}
    .feature .dot2{
      width:10px;height:10px;border-radius:3px;background:var(--accent);
      margin-top:6px;
      box-shadow: 0 6px 18px rgba(204,85,0,0.08);
    }
    .feature p{margin:0;color:var(--muted);font-size:14px}

    footer.small{
      margin-top:18px;
      color:rgba(107,114,128,0.6);
      font-size:13px;
      display:flex;
      justify-content:space-between;
      align-items:center;
    }

    .copyright{
      font-size:13px;
      color:rgba(107,114,128,0.55);
    }

    /* Modal viewer */
    .modal {
      position: fixed;
      inset: 0;
      display: none;
      align-items: center;
      justify-content: center;
      background: rgba(3,6,12,0.45);
      z-index: 1200;
    }
    .modal.open { display:flex; }
    .modal-inner{
      width:95%;
      max-width:1100px;
      height:86vh;
      background:#0b1320;
      border-radius:10px;
      overflow:hidden;
      box-shadow: 0 30px 80px rgba(11,20,40,0.6);
      border:1px solid rgba(255,255,255,0.04);
    }
    .modal-top{
      display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:linear-gradient(90deg, rgba(11,20,40,0.06), rgba(11,20,40,0.02));
      color:#fff;
    }
    .modal-top .title{font-weight:700}
    .modal-top .close{background:transparent;border:0;color:#fff;font-size:16px;cursor:pointer;padding:8px}
    .pdf-frame{width:100%;height:calc(100% - 46px);border:0;background:#fff;}
  </style>
</head>

<body>
  <div class="wrap">
    <div class="hero">
      <span class="eyebrow">Portfolio · Cloud Infrastructure</span>
      <h1>Production AWS Infrastructure — secure, scalable, documented</h1>
      <p class="lead">VPC isolation, bastion pattern, IAM RBAC, NAT gateway, and hardened network controls — packaged as a reproducible demo and portfolio artifact.</p>

      <div class="badges">
        <span class="badge">VPC</span>
        <span class="badge">EC2</span>
        <span class="badge">IAM</span>
        <span class="badge">S3</span>
      </div>

      <div class="cards">
        <div class="card">
          <h3>Architecture</h3>
          <p>Custom VPC (10.0.0.0/16) with public/private subnets, IGW + NAT Gateway, and a bastion host for private SSH access.</p>
        </div>
        <div class="card">
          <h3>Security</h3>
          <p>Defense-in-depth: IGW → NACL → Security Groups → IAM. Ephemeral port management for outbound success.</p>
        </div>
        <div class="card">
          <h3>Access Control</h3>
          <p>Admin group with scoped full access. Dev group with EC2 read-only. Enforced principle of least privilege.</p>
        </div>
        <div class="card">
          <h3>Automation</h3>
          <p>Bootstrap scripts for reproducible environment setup and clean documentation for audits and maintenance.</p>
        </div>
      </div>

      <div class="features">
        <div class="feature">
          <span class="dot2"></span>
          <p><strong>2 EC2</strong> — Public NGINX + Private app server</p>
        </div>
        <div class="feature">
          <span class="dot2"></span>
          <p><strong>1 NAT Gateway</strong> — Secure outbound access for private subnet</p>
        </div>
      </div>

      <footer class="small">
        <span>Created Oct 2025 • Clean, production-minded demo for portfolio</span>
        <span class="copyright">© Chiranjibi Dewangan</span>
      </footer>
    </div>

    <aside class="aside">
      <div class="status">
        <span class="dot"></span>
        <div><strong>Live Demo</strong><div class="small">Static website hosted on S3</div></div>
      </div>

      <div class="side-card">
        <h4>Portfolio</h4>
        <p class="small">View or download a polished PDF copy of my full portfolio and project documentation.</p>
        <div class="cta-row">
          <button id="openPdf" class="btn btn-primary" type="button">View PDF</button>
          <a id="downloadLink" class="btn btn-outline" href="#" download>Download PDF</a>
        </div>
      </div>

      <div class="side-card">
        <h4>Quick facts</h4>
        <p class="small">Multi-layer security, documented setup steps, and cost-conscious design (free-tier friendly where possible).</p>
      </div>
    </aside>
  </div>

  <div id="modal" class="modal">
    <div class="modal-inner">
      <div class="modal-top">
        <div class="title">Portfolio — PDF</div>
        <button id="closeModal" class="close" aria-label="Close PDF viewer">✕</button>
      </div>
      <iframe id="pdfFrame" class="pdf-frame" src="" title="Portfolio PDF"></iframe>
    </div>
  </div>

  <script>
    const PDF_URL = 'https://devops-portfolio-infra-chiranjibi-oct25.s3-website-us-east-1.amazonaws.com/portfolio.pdf';
    const openBtn = document.getElementById('openPdf');
    const modal = document.getElementById('modal');
    const closeBtn = document.getElementById('closeModal');
    const pdfFrame = document.getElementById('pdfFrame');
    const downloadLink = document.getElementById('downloadLink');

    downloadLink.href = PDF_URL;
    downloadLink.setAttribute('target','_blank');

    openBtn.addEventListener('click', () => {
      pdfFrame.src = PDF_URL;
      modal.classList.add('open');
    });
    closeBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', (e) => { if(e.target===modal) closeModal(); });
    function closeModal(){ modal.classList.remove('open'); pdfFrame.src=''; }
    document.addEventListener('keydown', (e) => {
      if(e.key==='Escape' && modal.classList.contains('open')) closeModal();
    });
  </script>
</body>
</html>
EOF

