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
    vector<int> pin;        // Menyimpan 4 angka PIN (Rotor setting)
    string password;        // Menyimpan password (Plugboard/Key setting)
    
    // Rentang ASCII yang bisa dicetak (Space ' ' s/d Tilde '~')
    const int ASCII_START = 32;
    const int ASCII_END = 126;
    const int RANGE = 95;

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

    // LOGIKA PERGESERAN DINAMIS
    int calculateShift(int msgIndex) {
        if (password.empty()) return 0;

        int passVal = (int)password[msgIndex % password.length()];
        int pinVal = pin[msgIndex % 4];
        
        // (Password + PIN + Posisi) -> Dinamis
        return (passVal + pinVal + msgIndex); 
    }

    // ENKRIPSI
    string encrypt(string message) {
        string result = "";
        for (int i = 0; i < message.length(); i++) {
            char c = message[i];
            if (c >= ASCII_START && c <= ASCII_END) {
                int originalVal = c - ASCII_START;
                int shift = calculateShift(i);
                int encryptedVal = (originalVal + shift) % RANGE;
                if (encryptedVal < 0) encryptedVal += RANGE;
                result += (char)(encryptedVal + ASCII_START);
            } else {
                result += c;
            }
        }
        return result;
    }

    // DEKRIPSI
    string decrypt(string cipherText) {
        string result = "";
        for (int i = 0; i < cipherText.length(); i++) {
            char c = cipherText[i];
            if (c >= ASCII_START && c <= ASCII_END) {
                int cipherVal = c - ASCII_START;
                int shift = calculateShift(i);
                int decryptedVal = (cipherVal - shift) % RANGE;
                if (decryptedVal < 0) decryptedVal += RANGE;
                result += (char)(decryptedVal + ASCII_START);
            } else {
                result += c;
            }
        }
        return result;
    }
    
    void showConfig() {
        cout << "\n=== Status Enigmorph ===" << endl;
        cout << "PIN Rotor : " << pin[0] << "-" << pin[1] << "-" << pin[2] << "-" << pin[3] << endl;
        cout << "Password  : " << password << endl; 
        cout << "========================\n" << endl;
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
    cout << "\n=== INISIALISASI SISTEM ===\n" << endl;
    
    while (true) {
        cout << "Masukkan PIN (4 angka, cth: 1945 atau 1 9 4 5): ";
        // Gunakan getline agar bisa membaca spasi ataupun tanpa spasi
        getline(cin, rawPinInput);

        cleanPin.clear();
        // Loop setiap karakter input user
        for (char c : rawPinInput) {
            // Jika karakter adalah angka, masukkan ke vector
            if (isdigit(c)) {
                // Konversi char '5' menjadi int 5 dengan cara mengurangi char '0'
                cleanPin.push_back(c - '0');
            }
        }

        // Cek apakah user memasukkan tepat 4 angka
        if (cleanPin.size() == 4) {
            // Jika benar, set ke mesin dan keluar dari loop
            enigmorph.setPin(cleanPin[0], cleanPin[1], cleanPin[2], cleanPin[3]);
            break; 
        } else {
            cout << "[ERROR] Terdeteksi " << cleanPin.size() << " angka. Harap masukkan tepat 4 angka!" << endl;
        }
    }

    cout << "Masukkan Password (teks): ";
    // Menggunakan getline untuk password agar password bisa mengandung spasi
    // Tapi di sini kita pakai cin >> pwd untuk satu kata, atau getline jika ingin kalimat.
    // Gunakan getline agar lebih aman bercampur dengan buffer sebelumnya.
    getline(cin, pwd);
    // Jika user langsung enter tanpa isi (kosong), minta ulang (opsional) atau biarkan.
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
        
        // Validasi input menu agar tidak crash jika input huruf
        if (!(cin >> choice)) {
            cout << "Input tidak valid!" << endl;
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            continue;
        }
        cin.ignore(); // Membersihkan buffer enter setelah cin >> choice

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
            
            // Logika Input PIN untuk ubah konfigurasi mesin
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