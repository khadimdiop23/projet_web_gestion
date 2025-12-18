<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times">
    
<xsl:output method="html" indent="yes" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>

<!-- Template principal -->
<xsl:template match="/">
<html>
<head>
    <title>Horaires des Transports Urbains</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Arial', sans-serif;
        }
        
        body {
            background-color: #f5f5f5;
            padding: 20px;
            color: #333;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .subtitle {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .controls {
            background-color: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .stats {
            font-size: 1.1em;
            color: #6c757d;
        }
        
        .filter-options {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        select {
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            background-color: white;
            font-size: 1em;
        }
        
        .horaires-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .horaires-table th {
            background-color: #2c3e50;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: bold;
            position: sticky;
            top: 0;
        }
        
        .horaires-table tr {
            border-bottom: 1px solid #e9ecef;
        }
        
        .horaires-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .horaires-table td {
            padding: 15px;
            vertical-align: middle;
        }
        
        .ligne-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            color: white;
            font-weight: bold;
            text-align: center;
            min-width: 60px;
        }
        
        .ligne-T1 {
            background-color: #e74c3c;
        }
        
        .ligne-F2 {
            background-color: #3498db;
        }
        
        .direction {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 0.9em;
            background-color: #ecf0f1;
            color: #2c3e50;
        }
        
        .heure {
            font-weight: bold;
            font-size: 1.2em;
            color: #2c3e50;
        }
        
        .type-passage {
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
        }
        
        .type-Normal {
            background-color: #d5f4e6;
            color: #27ae60;
        }
        
        .type-Express {
            background-color: #ffeaa7;
            color: #f39c12;
        }
        
        .station-info {
            display: flex;
            flex-direction: column;
        }
        
        .station-name {
            font-weight: bold;
            font-size: 1.1em;
        }
        
        .station-id {
            font-size: 0.9em;
            color: #7f8c8d;
        }
        
        footer {
            background-color: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #6c757d;
            border-top: 1px solid #e9ecef;
        }
        
        @media (max-width: 768px) {
            .controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .horaires-table {
                display: block;
                overflow-x: auto;
            }
            
            .horaires-table th,
            .horaires-table td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>📅 Horaires des Transports Urbains</h1>
            <p class="subtitle">Système de gestion des transports - Données en temps réel</p>
        </header>
        
        <div class="controls">
            <div class="stats">
                <xsl:text>Total: </xsl:text>
                <xsl:value-of select="count(//horaire)"/>
                <xsl:text> passages | Date: </xsl:text>
                <xsl:value-of select="substring(//horaire[1]/timestamp, 1, 10)"/>
            </div>
            
            <div class="filter-options">
                <label for="ligne-filter">Filtrer par ligne:</label>
                <select id="ligne-filter" onchange="filterTable()">
                    <option value="all">Toutes les lignes</option>
                    <option value="1">T1 (Tram)</option>
                    <option value="2">F2 (Bus Rapide)</option>
                </select>
                
                <label for="sort-order">Trier par:</label>
                <select id="sort-order" onchange="sortTable()">
                    <option value="heure">Heure</option>
                    <option value="ligne">Ligne</option>
                    <option value="station">Station</option>
                </select>
            </div>
        </div>
        
        <table class="horaires-table" id="horairesTable">
            <thead>
                <tr>
                    <th>Ligne</th>
                    <th>Station</th>
                    <th>Heure</th>
                    <th>Direction</th>
                    <th>Type</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="//horaire">
                    <xsl:sort select="timestamp" order="ascending"/>
                </xsl:apply-templates>
            </tbody>
        </table>
        
        <footer>
            <p>© 2025 Service de Transports Urbains - Données mises à jour en temps réel</p>
            <p>Dernière génération: <xsl:value-of select="format-dateTime(current-dateTime(), '[D]/[M]/[Y] [H]:[m]')"/></p>
        </footer>
    </div>
    
    <script>
        function filterTable() {
            const filterValue = document.getElementById('ligne-filter').value;
            const rows = document.querySelectorAll('.horaires-table tbody tr');
            
            rows.forEach(row => {
                if (filterValue === 'all') {
                    row.style.display = '';
                } else {
                    const ligneId = row.querySelector('.ligne-id').textContent;
                    if (ligneId === filterValue) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            });
        }
        
        function sortTable() {
            const sortBy = document.getElementById('sort-order').value;
            const tbody = document.querySelector('.horaires-table tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            rows.sort((a, b) => {
                let aValue, bValue;
                
                switch(sortBy) {
                    case 'heure':
                        aValue = a.querySelector('.heure').textContent;
                        bValue = b.querySelector('.heure').textContent;
                        break;
                    case 'ligne':
                        aValue = a.querySelector('.ligne-badge').textContent;
                        bValue = b.querySelector('.ligne-badge').textContent;
                        break;
                    case 'station':
                        aValue = a.querySelector('.station-name').textContent;
                        bValue = b.querySelector('.station-name').textContent;
                        break;
                    default:
                        return 0;
                }
                
                return aValue.localeCompare(bValue);
            });
            
            // Réorganiser les lignes
            rows.forEach(row => tbody.appendChild(row));
        }
    </script>
</body>
</html>
</xsl:template>

<!-- Template pour chaque horaire -->
<xsl:template match="horaire">
    <tr>
        <td>
            <xsl:variable name="ligneId" select="ligne"/>
            <span class="ligne-id" style="display: none;">
                <xsl:value-of select="$ligneId"/>
            </span>
            <xsl:choose>
                <xsl:when test="$ligneId = '1'">
                    <span class="ligne-badge ligne-T1">T1</span>
                </xsl:when>
                <xsl:when test="$ligneId = '2'">
                    <span class="ligne-badge ligne-F2">F2</span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="ligne-badge">L<xsl:value-of select="$ligneId"/></span>
                </xsl:otherwise>
            </xsl:choose>
        </td>
        
        <td>
            <div class="station-info">
                <span class="station-name">
                    <xsl:choose>
                        <xsl:when test="station = '1'">Gare Centre</xsl:when>
                        <xsl:when test="station = '2'">Hotel de Ville</xsl:when>
                        <xsl:when test="station = '3'">Université</xsl:when>
                        <xsl:otherwise>Station <xsl:value-of select="station"/></xsl:otherwise>
                    </xsl:choose>
                </span>
                <span class="station-id">ID: <xsl:value-of select="station"/></span>
            </div>
        </td>
        
        <td>
            <span class="heure">
                <xsl:value-of select="substring(timestamp, 12, 5)"/>
            </span>
            <br/>
            <small>
                <xsl:value-of select="substring(timestamp, 1, 10)"/>
            </small>
        </td>
        
        <td>
            <span class="direction">
                <xsl:value-of select="direction"/>
            </span>
        </td>
        
        <td>
            <xsl:choose>
                <xsl:when test="type_passage = 'Express'">
                    <span class="type-passage type-Express">EXPRESS</span>
                </xsl:when>
                <xsl:otherwise>
                    <span class="type-passage type-Normal">NORMAL</span>
                </xsl:otherwise>
            </xsl:choose>
        </td>
    </tr>
</xsl:template>

</xsl:stylesheet>