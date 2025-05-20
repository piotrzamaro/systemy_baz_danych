# === 1. Import bibliotek ===
import os
import csv
import MySQLdb
import shutil
from datetime import datetime



# === 2. Połączenie z MySQL ===
db = MySQLdb.connect(host= "213.184.8.44",
                     user="sp_zamarop",
                     passwd="piotr",
                     db="orcl")
cur = db.cursor()

# Tworzenie tabeli jeśli nie istnieje
cur.execute("""
CREATE TABLE IF NOT EXISTS dane (
    data DATE,
    godzina TIME,
    liczba1 FLOAT,
    liczba2 FLOAT,
    dodatkowa_kolumna FLOAT,
    PRIMARY KEY (data, godzina)
);
""")
db.commit()

# === 3. Wczytywanie danych z plików csv1 ===
source_folder = os.path.join("csv1", "csv1")
processed_folder = os.path.join("processed")
os.makedirs(processed_folder, exist_ok=True)

for file in os.listdir(source_folder):
    if file.endswith(".csv"):
        full_path = os.path.join(source_folder, file)
        with open(full_path, "r") as f:
            reader = csv.reader(f)
            for row in reader:
                data_int = int(float(row[0]))
                godzina_float = float(row[1])
                liczba1 = float(row[2])
                liczba2 = float(row[3]) if len(row) > 3 else None

                data_parsed = datetime.strptime(str(data_int), "%Y%m%d").date()
                godzina_parsed = f"{int(godzina_float):02d}:00:00"

                try:
                    cur.execute("""
                        INSERT INTO dane (data, godzina, liczba1, liczba2, dodatkowa_kolumna)
                        VALUES (%s, %s, %s, %s, NULL)
                    """, (data_parsed, godzina_parsed, liczba1, liczba2))
                except MySQLdb.IntegrityError:
                    pass  # pomiń duplikaty

        # === 4. Przenoszenie do podfolderu wg miesiąca ===
        miesiac = file[5:11]  # np. 201709
        mies_folder = os.path.join(processed_folder, miesiac)
        os.makedirs(mies_folder, exist_ok=True)
        shutil.move(full_path, os.path.join(mies_folder, file))

db.commit()

# === 5. Uzupełnianie kolumny z csv2 ===
csv2_folder = os.path.join("csv2", "csv2")
for file in os.listdir(csv2_folder):
    if file.endswith(".csv"):
        full_path = os.path.join(csv2_folder, file)
        with open(full_path, "r") as f:
            reader = csv.reader(f)
            for row in reader:
                data_int = int(float(row[0]))
                godzina_float = float(row[1])
                dodatkowa = float(row[2])

                data_parsed = datetime.strptime(str(data_int), "%Y%m%d").date()
                godzina_parsed = f"{int(godzina_float):02d}:00:00"

                cur.execute("""
                    UPDATE dane
                    SET dodatkowa_kolumna = %s
                    WHERE data = %s AND godzina = %s
                """, (dodatkowa, data_parsed, godzina_parsed))
db.commit()

# === 6. Średnie miesięczne liczba1 i liczba2 ===
cur.execute("""
SELECT DATE_FORMAT(data, '%Y-%m') AS miesiac,
       ROUND(AVG(liczba1), 2) AS srednia1,
       ROUND(AVG(liczba2), 2) AS srednia2
FROM dane
GROUP BY miesiac
ORDER BY miesiac;
""")

print("ŚREDNIE MIESIĘCZNE:")
for row in cur.fetchall():
    print(f"{row[0]} | liczba1: {row[1]} | liczba2: {row[2]}")

db.close()
