-- HAYVAN TABLOSUNU JOIN KULLANARAK LİSTELENMİŞ
SET STATISTICS IO ON
SELECT H.ID, T.Tur_Adi AS TUR, C.Cinsiyet_Adi AS CINSIYET, R.Renk_Adi AS RENK,
       H.Dogum_Tarihi AS DOGUM_TARIH, H.Agirlik AS AGIRLIK, 
       CASE 
           WHEN C.Cinsiyet_Adi != 'Boğa' THEN H.G_Verim_M 
           ELSE NULL 
       END AS GUNLUK_VERIM, 
       S.S_Durum AS SAGLIK_DURUM
FROM HAYVAN H
INNER JOIN TUR T ON T.ID = H.Tur_ID
INNER JOIN CINSIYET C ON C.ID = H.Cinsiyet_ID
INNER JOIN RENK R ON R.ID = H.Renk_ID
INNER JOIN SAGLIK S ON S.ID = H.Saglik_ID;
GO

-----------------------------------------------------------
-- HAYVAN TABLOSUNU SUBQUERY KULLANILARAK LİSTELENMİŞ

SET STATISTICS IO ON
SELECT H.ID,
       (SELECT T.Tur_Adi FROM TUR T WHERE T.ID = H.Tur_ID ) AS TUR,
       (SELECT C.Cinsiyet_Adi FROM CINSIYET C WHERE C.ID = H.Cinsiyet_ID) AS CINSIYET,
       (SELECT R.Renk_Adi FROM RENK R WHERE R.ID = H.Renk_ID) AS RENK,
       H.Dogum_Tarihi AS DOGUM_TARIH, H.Agirlik AS AGIRLIK, 
       CASE 
           WHEN (SELECT C.Cinsiyet_Adi FROM CINSIYET C WHERE C.ID = H.Cinsiyet_ID) != 'Boğa' THEN H.G_Verim_M 
           ELSE Null 
       END AS GUNLUK_VERIM,
       (SELECT S.S_Durum FROM SAGLIK S WHERE S.ID = H.Saglik_ID) AS SAGLIK_DURUM
FROM HAYVAN H;
GO

------------------------------------------------------
-- HAYVAN TABLOSUNUN ÖZELLİKLERİNE EK OLARAK VURULAN AŞI SUBQUERY İLE LİSTELENMİŞ
SELECT H.ID,
       (SELECT T.Tur_Adi FROM TUR T WHERE T.ID = H.Tur_ID ) AS TUR,
       (SELECT C.Cinsiyet_Adi FROM CINSIYET C WHERE C.ID = H.Cinsiyet_ID) AS CINSIYET,
       (SELECT R.Renk_Adi FROM RENK R WHERE R.ID = H.Renk_ID) AS RENK,
       H.Dogum_Tarihi AS DOGUM_TARIH, H.Agirlik AS AGIRLIK, H.G_Verim_M AS GUNLUK_VERIM,
       (SELECT S.S_Durum FROM SAGLIK S WHERE S.ID = H.Saglik_ID) AS SAGLIK_DURUM,
       (SELECT COUNT(VI.Ilac_ID) FROM VURULAN_ASI AS VI WHERE VI.Hayva_ID = H.ID) AS VURULAN_ASI_SAYISI,
       (SELECT TOP 1 I.Ilac_Adi FROM ILAC I INNER JOIN VURULAN_ASI VI ON VI.Ilac_ID = I.ID WHERE VI.Hayva_ID = H.ID) AS ILAC,
       (SELECT SUM(I.Ilac_Miktar) FROM ILAC I INNER JOIN VURULAN_ASI VI ON VI.Ilac_ID = I.ID WHERE VI.Hayva_ID = H.ID) AS TOPLAM_ILAC_MIKTAR
FROM HAYVAN H;
GO

-----------------------------------------------
SELECT * FROM HAYVAN;
SELECT * FROM SAGLIK;
SELECT * FROM CINSIYET;
GO

-- SAĞLIKLI HAYVAN SAYISI
SELECT COUNT(Saglik_ID) AS SAGLIKLI_H_SAYISI FROM HAYVAN WHERE Saglik_ID = 1;
GO

-- YARI SAĞLIKLI HAYVAN SAYISI
SELECT COUNT(Saglik_ID) AS YARI_SAGLIKLI_H_SAYISI FROM HAYVAN WHERE Saglik_ID = 2;
GO

-- HASTA HAYVAN SAYISI
SELECT COUNT(Saglik_ID) AS HASTA_H_SAYISI FROM HAYVAN WHERE Saglik_ID = 3;
GO

-- AĞIR HASTA HAYVAN SAYISI
SELECT COUNT(Saglik_ID) AS AGIR_HASTA_H_SAYISI FROM HAYVAN WHERE Saglik_ID = 4;
GO

------------- HAYVANLARIN TÜRLERİNE GÖRE ORTALAMA SÜT VERİMİ -------------
SELECT C.Cinsiyet_Adi, AVG(H.G_Verim_M) AS ORTALAMA_VERIM FROM HAYVAN H 
INNER JOIN CINSIYET C ON C.ID = H.Cinsiyet_ID WHERE C.Cinsiyet_Adi != 'Boğa' 
GROUP BY C.Cinsiyet_Adi; 
GO

-- VIEW OLUŞTURMA
CREATE VIEW VWHAYVAN 
AS
SELECT H.ID, T.Tur_Adi AS TUR, C.Cinsiyet_Adi AS CINSIYET, R.Renk_Adi AS RENK,
       H.Dogum_Tarihi AS DOGUM_TARIH, H.Agirlik AS AGIRLIK, H.G_Verim_M AS GUNLUK_VERIM, S.S_Durum AS SAGLIK_DURUM
FROM HAYVAN H
INNER JOIN TUR T ON T.ID = H.Tur_ID
INNER JOIN CINSIYET C ON C.ID = H.Cinsiyet_ID
INNER JOIN RENK R ON R.ID = H.Renk_ID
INNER JOIN SAGLIK S ON S.ID = H.Saglik_ID;
GO

-- VIEW KULLANARAK SORGULAMA
SELECT * FROM VWHAYVAN
WHERE CINSIYET = 'İnek' AND DOGUM_TARIH BETWEEN '2019-03-02' AND '2020-03-02';
GO

-- SCALAR FUNCTION OLUŞTURMA
CREATE FUNCTION dbo.HAYVAN_AGIRLIK (@HAYVAN_CINSI AS NVARCHAR(20))
RETURNS INT
AS
BEGIN
    DECLARE @TOPLAM AS INT;
    SET @TOPLAM = (SELECT SUM(AGIRLIK) FROM VWHAYVAN WHERE CINSIYET = @HAYVAN_CINSI);
    RETURN @TOPLAM;
END;
GO

-- SCALAR FUNCTION KULLANIMI
SELECT CONCAT('İnek = ', dbo.HAYVAN_AGIRLIK('İnek'), ' kg');
SELECT CONCAT('Boğa = ', dbo.HAYVAN_AGIRLIK('Boğa'), ' kg');
GO

-- STORED PROCEDURE OLUŞTURMA
CREATE PROCEDURE dbo.SP_CINSIYET_SAGLIKD
    @CINSIYET NVARCHAR(30),
    @SAGLIK_DURUM NVARCHAR(30)
AS
BEGIN
    IF @CINSIYET IS NULL
    BEGIN
        RAISERROR('Girdiğiniz cinsiyette hayvan bulunmamaktadır.', 16, 1);
        RETURN;
    END;

    SELECT H.ID, T.Tur_Adi AS TUR, C.Cinsiyet_Adi AS CINSIYET, R.Renk_Adi AS RENK,
           H.Dogum_Tarihi AS DOGUM_TARIH, H.Agirlik AS AGIRLIK, H.G_Verim_M AS GUNLUK_VERIM, S.S_Durum AS SAGLIK_DURUM,
           I.Ilac_Adi AS ILAC_AD, I.Ilac_Miktar AS ILAC_MIKTAR
    FROM HAYVAN H
    INNER JOIN TUR T ON T.ID = H.Tur_ID
    INNER JOIN CINSIYET C ON C.ID = H.Cinsiyet_ID
    INNER JOIN RENK R ON R.ID = H.Renk_ID
    INNER JOIN SAGLIK S ON S.ID = H.Saglik_ID
    LEFT JOIN VURULAN_ASI VI ON VI.Hayva_ID = H.ID
    LEFT JOIN ILAC I ON I.ID = VI.Ilac_ID
    WHERE C.Cinsiyet_Adi = @CINSIYET AND S.S_Durum = @SAGLIK_DURUM
    ORDER BY H.ID;
END;
GO

-- STORED PROCEDURE ÇALIŞTIRMA
EXEC dbo.SP_CINSIYET_SAGLIKD @CINSIYET = 'İnek', @SAGLIK_DURUM = 'Sağlıklı';
EXEC dbo.SP_CINSIYET_SAGLIKD @CINSIYET = 'Boğa', @SAGLIK_DURUM = 'Hasta';
GO
------Transaction başlat
BEGIN TRANSACTION; 

BEGIN TRY
    -- Yeni hayvan ekleme işlemi
    INSERT INTO HAYVAN (Tur_ID, Cinsiyet_ID, Renk_ID, Dogum_Tarihi, Agirlik, G_Verim_M, Saglik_ID)
    VALUES (1, 1, 1, '2024-01-01', 100, 20, 1);

    

    COMMIT TRANSACTION; -- Transaction'ı tamamla
    PRINT 'Hayvan başarıyla eklendi.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION; -- Hata oluştuğunda transaction'ı geri al
    PRINT 'Hata oluştu. İşlem geri alındı.';
    PRINT ERROR_MESSAGE(); -- Hata mesajını yazdır
END CATCH;
GO
-- INSERT trigger'ı
ALTER TRIGGER TRGINSERTED
ON HAYVAN
AFTER INSERT
AS
BEGIN
    UPDATE CiftlikDurum
    SET Toplam_H_Sayisi = Toplam_H_Sayisi + (SELECT COUNT(*) FROM inserted),
        Toplam_Agirlik = Toplam_Agirlik + ISNULL((SELECT SUM(Agirlik) FROM inserted), 0),
        Ort_Gun_Sut_Verimi = (SELECT AVG(G_Verim_M) FROM HAYVAN), -- Yeniden eklenen sütun
        Saglikli_Hayvan_Sayisi = (SELECT COUNT(*) FROM HAYVAN WHERE Saglik_ID = 1), -- Yeniden eklenen sütun
        Yari_Saglikli = Yari_Saglikli + (SELECT COUNT(*) FROM inserted WHERE Saglik_ID = 2),
        Hasta = Hasta + (SELECT COUNT(*) FROM inserted WHERE Saglik_ID = 3),
        Agir_Hasta = Agir_Hasta + (SELECT COUNT(*) FROM inserted WHERE Saglik_ID = 4);
END;
GO

-- UPDATE trigger'ı
CREATE TRIGGER TRGUPDATED
ON HAYVAN
AFTER UPDATE
AS
BEGIN
    UPDATE CiftlikDurum
    SET Yari_Saglikli = Yari_Saglikli - (SELECT COUNT(*) FROM deleted WHERE Saglik_ID = 2),
        Hasta = Hasta - (SELECT COUNT(*) FROM deleted WHERE Saglik_ID = 3),
        Agir_Hasta = Agir_Hasta - (SELECT COUNT(*) FROM deleted WHERE Saglik_ID = 4);

    UPDATE CiftlikDurum
    SET Toplam_Agirlik = (SELECT ISNULL(SUM(Agirlik), 0) FROM HAYVAN),
        Ort_Gun_Sut_Verimi = (SELECT AVG(G_Verim_M) FROM HAYVAN),-- Yeniden eklenen sütun
        Saglikli_Hayvan_Sayisi = (SELECT COUNT(*) FROM HAYVAN WHERE Saglik_ID = 1),-- Yeniden eklenen sütun
        Yari_Saglikli = Yari_Saglikli + (SELECT COUNT(*) FROM inserted WHERE Saglik_ID = 2),
        Hasta = Hasta + (SELECT COUNT(*) FROM inserted WHERE Saglik_ID = 3),
        Agir_Hasta = Agir_Hasta + (SELECT COUNT(*) FROM inserted WHERE Saglik_ID = 4);
END;
GO