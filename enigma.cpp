#include <iostream>
#include <string>
#include <vector>
#include <limits>
#include <cctype>

using namespace std;

// ================================
// KELAS ENIGMORPH (MESIN ENKRIPSI)
// ================================
class EnigmaMachine {
private:
    vector<int> pin;        // Menyimpan 4 angka PIN
    string password;        // Menyimpan password
    
    // Rentang ASCII yang bisa dicetak (Space ' ' s/d Tilde '~')
    const int ASCII_START = 32;
    const int ASCII_END = 126;
    const int RANGE = 95;

    // --- LOGIKA "GENERATOR ACAK" (CORE ALGORITHM) ---
    
    // Membuat "Seed" (Benih) Unik dari kombinasi PIN dan Password
    unsigned long long generateInitialSeed() {
        unsigned long long seed = 0;

        // Campurkan PIN ke dalam seed
        // Kalikan dengan (i+1) agar urutan PIN berpengaruh (1234 != 4321)
        for (size_t i = 0; i < pin.size(); ++i) {
            seed = seed * 10 + (pin[i] * (i + 1));
        }

        // Campurkan Password ke dalam seed
        // Menggunakan operasi bitwise sederhana untuk mengacak bit
        if (!password.empty()) {
            for (size_t i = 0; i < password.length(); ++i) {
                unsigned int charVal = (unsigned int)password[i];
                // Kalikan dengan angka prima sembarang (1337) untuk menyebar nilai
                seed += charVal * (i + 1337);
                // Geser bit dan XOR untuk efek pengacakan (mixing)
                seed ^= (seed << 5);
            }
        }

        // Pastikan seed tidak 0 agar perkalian matematika tidak macet
        if (seed == 0) seed = 123456789;

        return seed;
    }

    // Fungsi inti pemroses teks (Stream Cipher Logic)
    string runCipherOperation(string input, bool isEncrypt) {
        if (input.empty()) return "";

        // Bangkitkan Seed awal dari konfigurasi saat ini
        unsigned long long currentSeed = generateInitialSeed();

        string result = "";
        
        // Proses setiap karakter
        for (char c : input) {
            int charCode = (int)c;

            // Hanya proses karakter ASCII yang bisa dicetak (32-126)
            if (charCode >= ASCII_START && charCode <= ASCII_END) {

                // --- ALGORITMA PENGACAK (Linear Congruential Generator / LCG) ---
                // Rumus klasik: next = (prev * A + B)
                // Konstanta standar POSIX/GCC untuk LCG
                currentSeed = (currentSeed * 1103515245 + 12345);

                // Ambil bit bagian tengah/atas sebagai angka acak, lalu modulo RANGE (95)
                // (currentSeed / 65536) membuang bit rendah yang polanya kurang acak
                int randomShift = (currentSeed / 65536) % RANGE;

                // --- PROSES GESER ---
                int originalVal = charCode - ASCII_START;
                int processedVal;

                if (isEncrypt) {
                    // Enkripsi: Geser MAJU tambah angka acak
                    processedVal = (originalVal + randomShift) % RANGE;
                } else {
                    // Dekripsi: Geser MUNDUR kurangi angka acak
                    processedVal = (originalVal - randomShift) % RANGE;

                    // Koreksi hasil negatif (karena sifat modulo C++ bisa negatif)
                    if (processedVal < 0) {
                        processedVal += RANGE;
                    }
                }

                result += (char)(processedVal + ASCII_START);
            } else {
                // Jika karakter spesial (emoji, enter, tab), biarkan apa adanya
                result += c;
            }
        }
        return result;
    }

public:
    EnigmaMachine() {
        pin = {0, 0, 0, 0};
        password = "default";
    }

    void setPin(int d1, int d2, int d3, int d4) {
        pin = {d1, d2, d3, d4};
    }

    void setPassword(string pwd) {
        password = pwd;
    }

    // Wrapper untuk Enkripsi
    string encrypt(string message) {
        return runCipherOperation(message, true);
    }

    // Wrapper untuk Dekripsi
    string decrypt(string cipherText) {
        return runCipherOperation(cipherText, false);
    }
    
    void showConfig() {
        cout << "\n=== Status Enigmorph (Enhanced Engine) ===" << endl;
        cout << "PIN Rotor : " << pin[0] << "-" << pin[1] << "-" << pin[2] << "-" << pin[3] << endl;
        cout << "Password  : " << password << endl; 
        cout << "==========================================\n" << endl;
    }
};

// ============
// FUNGSI UTAMA
// ============
int main() {
    EnigmaMachine enigmorph;
    int choice;
    string pwd, msg;
    
    // Variabel untuk logika input PIN baru
    string rawPinInput;
    vector<int> cleanPin;

    // TAMPILAN JUDUL
    cout << "  _____       _                                  _       " << endl;
    cout << " | ____|_ __ (_) __ _ _ __ ___   ___  _ __ _ __ | |__    " << endl;
    cout << " |  _| | '_ \\  |/ _` | '_ ` _ \\ / _ \\| '__| '_ \\| '_ \\   " << endl;
    cout << " | |___| | | | | (_| | | | | | | (_) | |  | |_) | | | |  " << endl;
    cout << " |_____|_| |_|_|\\__, |_| |_| |_|\\___/|_|  | .__/|_| |_|  " << endl;
    cout << "                |___/                     |_|            " << endl;

    // --- LOGIKA INPUT PIN ---
    cout << "\n=== INISIALISASI SISTEM (VERSI UPDATED) ===\n" << endl;
    
    while (true) {
        cout << "Masukkan PIN (4 angka, cth: 1945 atau 1 9 4 5): ";
        getline(cin, rawPinInput);

        cleanPin.clear();
        for (char c : rawPinInput) {
            if (isdigit(c)) {
                cleanPin.push_back(c - '0');
            }
        }

        if (cleanPin.size() == 4) {
            enigmorph.setPin(cleanPin[0], cleanPin[1], cleanPin[2], cleanPin[3]);
            break; 
        } else {
            cout << "[ERROR] Terdeteksi " << cleanPin.size() << " angka. Harap masukkan tepat 4 angka!" << endl;
        }
    }

    cout << "Masukkan Password (teks): ";
    getline(cin, pwd);
    if(pwd.empty()) {
        cout << "Password kosong, menggunakan default." << endl;
        pwd = "default";
    }
    enigmorph.setPassword(pwd);
    
    do {
        cout << "\n\n===============================" << endl;
        cout << "   ENIGMORPH - SECURE SYSTEM   " << endl;
        cout << "===============================" << endl;
        enigmorph.showConfig();
        cout << "1. Enkripsi Pesan" << endl;
        cout << "2. Dekripsi Pesan" << endl;
        cout << "3. Ubah Konfigurasi" << endl;
        cout << "4. Keluar" << endl;
        cout << "\nPilihan Anda: ";
        
        if (!(cin >> choice)) {
            cout << "Input tidak valid!" << endl;
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            continue;
        }
        cin.ignore(); // Membersihkan buffer

        switch (choice) {
        case 1:
            cout << "\n[MODE ENKRIPSI]" << endl;
            cout << "Masukkan pesan rahasia: ";
            getline(cin, msg);
            cout << "\n============================\n";
            cout << "Hasil Enkripsi (Ciphertext): \n\n" << enigmorph.encrypt(msg) << endl;
            cout << "============================";
            cout << "\n(Salin teks di atas)" << endl;
            break;

        case 2:
            cout << "\n[MODE DEKRIPSI]" << endl;
            cout << "Masukkan pesan teracak: ";
            getline(cin, msg);
            cout << "\n============================\n";
            cout << "Hasil Dekripsi (Plaintext): \n\n" << enigmorph.decrypt(msg) << endl;
            cout << "============================";
            break;

        case 3:
            cout << "\n[UBAH KONFIGURASI]" << endl;
            
            while (true) {
                cout << "Masukkan 4 angka PIN baru: ";
                getline(cin, rawPinInput);
                cleanPin.clear();
                for (char c : rawPinInput) {
                    if (isdigit(c)) cleanPin.push_back(c - '0');
                }
                if (cleanPin.size() == 4) {
                    enigmorph.setPin(cleanPin[0], cleanPin[1], cleanPin[2], cleanPin[3]);
                    break; 
                } else {
                    cout << "[ERROR] Harap masukkan tepat 4 angka!" << endl;
                }
            }

            cout << "Masukkan Password baru: ";
            getline(cin, pwd);
            enigmorph.setPassword(pwd);
            cout << "Konfigurasi diperbarui!" << endl;
            break;

        case 4:
            cout << "\n==== System Shutdown... ====" << endl;
            break;

        default:
            cout << "Pilihan tidak valid." << endl;
        }

    } while (choice != 4);

    return 0;
}