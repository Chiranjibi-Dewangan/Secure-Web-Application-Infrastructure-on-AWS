#!/bin/bash
yum update -y
yum install nginx -y
systemctl start nginx
systemctl enable nginx

# Create custom landing page

cat <<'EOF' | sudo tee /usr/share/nginx/html/index.html > /dev/null
<!DOCTYPE html>
<html>
<head>
    <title>Secure AWS Infrastructure Project</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: white;
            padding: 60px;
            border-radius: 10px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 900px;
            text-align: center;
        }
        h1 { 
            color: #667eea; 
            font-size: 2.5em;
            margin-bottom: 15px;
        }
        .subtitle {
            color: #666;
            font-size: 1.1em;
            margin-bottom: 40px;
            line-height: 1.6;
        }
        .achievement-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            margin: 50px 0;
        }
        .achievement {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        .achievement-number {
            font-size: 2.5em;
            color: #667eea;
            font-weight: bold;
        }
        .achievement-label {
            color: #666;
            font-size: 0.95em;
            margin-top: 10px;
        }
        .cta-buttons {
            margin-top: 50px;
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .button {
            display: inline-block;
            padding: 15px 30px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
            font-size: 1em;
        }
        .button-primary {
            background: #667eea;
            color: white;
        }
        .button-primary:hover {
            background: #764ba2;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .button-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        .button-secondary:hover {
            background: #f0f2ff;
        }
        .status-badge {
            display: inline-block;
            background: #d4edda;
            color: #155724;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1> Production-Grade AWS Infrastructure</h1>
        <p class="subtitle">
            Enterprise-level secure cloud architecture demonstrating VPC isolation, 
            defense-in-depth security, and role-based access control.
        </p>
        
        <div class="achievement-grid">
            <div class="achievement">
                <div class="achievement-number">4</div>
                <div class="achievement-label">Security Layers</div>
            </div>
            <div class="achievement">
                <div class="achievement-number">15+</div>
                <div class="achievement-label">AWS Resources</div>
            </div>
            <div class="achievement">
                <div class="achievement-number">10/10</div>
                <div class="achievement-label">Tests Passed</div>
            </div>
        </div>

        <div class="status-badge"> Multi-layer security operational</div>

        <div class="cta-buttons">
            <a href="https://github.com/yourusername/aws-secure-infrastructure" class="button button-primary">
                 View Full Documentation
            </a>
            <a href="https://linkedin.com/in/yourprofile" class="button button-secondary">
                 Connect on LinkedIn
            </a>
        </div>

        <p style="color: #999; font-size: 0.9em; margin-top: 40px;">
            This server is part of a portfolio project demonstrating AWS infrastructure design principles.
        </p>
    </div>
</body>
</html>
EOF

