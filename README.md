# farm-database 
Hayvan Veritabanı Yönetim Sistemi                                 
-                                           
Bu proje, bir Hayvan Veritabanı Yönetim Sistemi uygulamasıdır. Hayvanların kayıt edilmesi, sağlık durumlarının izlenmesi, aşı ve ilaç bilgilerinin yönetilmesi gibi işlemler gerçekleştirilebilir. Uygulama, SQL tabanlı bir veritabanı üzerinde çalışmakta olup veriler JOIN, Subquery, Stored Procedure ve Trigger kullanılarak yönetilmektedir.

Özellikler
-
✅ Hayvan Ekleme: Yeni bir hayvanın bilgileri (tür, cinsiyet, renk, doğum tarihi vb.) sisteme eklenir.

✅ Hayvan Silme: Var olan bir hayvan kaydı sistemden kaldırılır.

✅ Hayvan Güncelleme: Hayvanın sağlık durumu, ağırlık veya süt verimi gibi bilgileri güncellenir.

✅ Aşı Ekleme: Bir hayvana uygulanan aşı bilgileri kaydedilir.

✅ İlaç Ekleme: Bir hayvana uygulanan ilaç bilgileri kaydedilir.

✅ Hayvan Listeleme: Kayıtlı hayvanlar ve detayları listelenir.

✅ İstatistiksel Veriler: Sağlık durumuna, cinsiyete ve süt verimine göre analiz yapılır.

✅ En Yüksek Süt Verimi: En fazla süt veren hayvanlar görüntülenir.

Kullanım
-
➡️ Hayvan Ekleme:
Hayvanın türü, cinsiyeti, ağırlığı, doğum tarihi ve diğer bilgileri girilerek eklenir.

➡️ Hayvan Silme:
Silinmek istenen hayvanın ID’si veya adı girilerek silinir.

➡️ Hayvan Güncelleme:
Güncellenmek istenen hayvanın ID’si seçilerek yeni bilgiler girilir ve güncellenir.

➡️ Aşı ve İlaç Ekleme:
Hayvan ID’si seçilir, uygulanan aşı veya ilaç bilgisi girilerek eklenir.

➡️ Hayvan Listeleme:
Tüm hayvanlar veya belirli türdeki hayvanlar listelenir.

➡️ En Yüksek Süt Verimi:
En fazla süt veren hayvanlar sıralanır.

Gereksinimler
-
SQL tabanlı veritabanı (PostgreSQL veya MSSQL)

JDBC bağlantısı

Java 8 veya daha yüksek bir sürüm

Kullanılan Yapılar
-
📌 Veritabanı: Hayvan, Tür, Cinsiyet, Renk ve Sağlık Durumu tabloları

📌 Stored Procedure: Belirli kriterlere göre hayvan sorgulaması

📌 JOIN: Birden fazla tablo arasında ilişki kurarak veri listeleme

📌 Trigger: Yeni kayıt ekleme ve güncelleme işlemlerinde otomatik istatistik güncelleme

📌 Function: Ortalama süt verimi ve toplam hayvan sayısı hesaplamaları

Kurulum
-
Projeyi GitHub üzerinden veya bir zip dosyası olarak indirin.

Java geliştirme ortamınıza (IDE) projeyi aktarın.

Veritabanı bağlantı ayarlarını yapılandırın.

Uygulamayı başlatın ve arayüz üzerinden işlemlerinizi gerçekleştirin.

* Bu yapı sayesinde hayvan kayıtları kolayca yönetilebilir, güncellenebilir ve analiz edilebilir. 🐄 🐑 🐖

