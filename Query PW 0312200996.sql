-- 1 Trovo tutti i passeggeri con biglietti superiori ai 40€

Select distinct (p.Cod_passeggero), p.Nome, p.Cognome, p.Email
from Passeggero p
join Titolo_di_viaggio tdv on p.Cod_passeggero = tdv.Cod_passeggero
where tdv.Tariffa > 40
order by p.Cod_passeggero;

-- 2 Trovo solo i biglietti emessi nel 2022

Select tdv.Cod_biglietto, tdv.Tariffa, tdv.Stato
from Titolo_di_viaggio tdv
where tdv.Data_emissione between '2022-01-01' and '2022-12-31'
order by tdv.Cod_biglietto;

-- 3 Viaggi con biglietti attivi

Select v.Cod_corsa, v.Data_partenza, v.Ora_partenza, v.Ora_arrivo
from Viaggio v
join Titolo_di_viaggio tdv on v.Cod_biglietto = tdv.Cod_biglietto
where tdv.Stato = 'Attivo'
order by v.Data_partenza desc;

-- 4 Clienti fidelizzati con tessera Venezia Unica e residenti a Venezia

Select VU.Cod_ClienteFidelizzato, VU.Profilo, VU.Scadenza_profilo
from Tessera_VeneziaUnica VU
where VU.Residenza_Venezia = 1
order by VU.Scadenza_profilo desc;

-- 5 Trovo i clienti fidelizzati con il profilo in scadenza nei prossimi 300 giorni

Select VU.Cod_ClienteFidelizzato, VU.Profilo, VU.Scadenza_profilo
from Tessera_VeneziaUnica VU
where VU.Scadenza_profilo between cast (getdate() as date) and dateadd (day, 300, cast(getdate() as date))
order by VU.Scadenza_profilo desc;

-- 6 Utenti con più di 10 titoli acquistati nell'applicazione con ordinamento rispetto i titoli utilizzati

Select App.Email_Utente_Registrato, App.Borsellino, App.Titoli_acquistati, App.Titoli_utilizzati
from Applicazione App
where App.Titoli_acquistati > 10
order by App.Titoli_utilizzati desc;

-- 7 Trovo Tap EMV con BestFare attivo e recupero il cliente che lo ha fatto

Select Emv.Cod_tap_EMV, Emv.Cod_Fermata, Emv.Tariffa, p.Email, p.Nome, p.Cognome
from EMV Emv
join Tessera_VeneziaUnica VU on Emv.Cod_ClienteFidelizzato = VU.Cod_ClienteFidelizzato
join Passeggero p on VU.Cod_passeggero = p.Cod_passeggero
where Emv.BestFare = 1
order by Emv.Cod_tap_EMV;

-- 8 Dispositivi che hanno validato e controllato recuperando il proprietario del biglietto

Select vc.ID_Dispositivo, vc.Tipo_Dispositivo, vc.Validazione, vc.Controllo, p.Nome, p.Cognome
from Validazione_e_controllo vc
join Passeggero p on vc.Cod_passeggero = p.Cod_passeggero
where vc.Validazione = 1 
and vc.Controllo = 1
order by vc.ID_Dispositivo;

-- 9 Numero di biglietti acquistati per canale di vendita

Select 
    sum(cast(Biglietteria as int)) as Totale_Biglietteria,
    sum(cast(Online as int)) as Totale_Online,
    sum(cast(Distributore_automatico as int)) as Totale_Distributore_Automatico,
    sum(cast(Rivendite_esterne as int)) as Totale_Rivendite_Esterne
from Modalità_acquisto_titolo;

-- 10 Trovo i passeggeri con più di un biglietto e recupero il nome e cognome

Select tdv.Cod_passeggero, p.Nome, p.Cognome , count(tdv.Cod_biglietto) as Numero_Biglietti
from Titolo_di_viaggio tdv
join Passeggero p on tdv.Cod_passeggero = p.Cod_passeggero
group by tdv.Cod_passeggero, p.Nome, p.Cognome
having count(Cod_biglietto) > 1;

-- 11 Clienti con più di 2 tap EMV e recupero il nome e il cognome

Select emv.Cod_ClienteFidelizzato, p.Nome, p.Cognome, count(emv.Cod_tap_EMV) as Numero_Tap
from EMV emv
join Tessera_VeneziaUnica VU on emv.Cod_ClienteFidelizzato = VU.Cod_ClienteFidelizzato
join Passeggero p on VU.Cod_passeggero = p.Cod_passeggero
group by emv.Cod_ClienteFidelizzato, p.Nome, p.Cognome
having count(emv.Cod_tap_EMV) > 2;
