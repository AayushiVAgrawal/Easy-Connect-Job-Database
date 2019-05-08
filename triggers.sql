
/* ---- START ServiceFeesUpdate TRIGGER ----  */

CREATE TABLE ServiceFeesUpdates_Log
(
	ServiceID int,
	ServiceName varchar(1000),
	ServiceDescription  varchar(1000),
	OldFees float,
	NewFees float,
	ServiceDate datetime
)

GO

CREATE TRIGGER ServiceFeesUpdate ON ConsultationService_T
FOR UPDATE AS IF UPDATE(ServiceFee)
BEGIN
INSERT INTO ServiceFeesUpdates_Log 
(ServiceID, ServiceName, ServiceDescription, OldFees, NewFees, ServiceDate)
SELECT inserted.ServiceID, inserted.ServiceName, inserted.ServiceDescription,
		deleted.ServiceFee, inserted.ServiceFee, GETDATE() 
FROM inserted, deleted WHERE inserted.ServiceID = deleted.ServiceID
END

UPDATE ConsultationService_T SET ServiceFee = 999.12 WHERE ServiceID = 123459
UPDATE ConsultationService_T SET ServiceFee = 100.0 WHERE ServiceName = 'Career path guidance'

SELECT * FROM  ServiceFeesUpdates_Log;

/* ---- END ServiceFeesUpdate TRIGGER ----  */


/* ---- START PaymentUpdate TRIGGER ----  */
CREATE TABLE PaymentUpdates_Log
(
	PaymentID int,
	PaymentType nvarchar(max),
	OldPaymentAmount float,
	NewPaymentAmount float,
	UpdateDate datetime
)

GO 

CREATE TRIGGER PaymentUpdate ON Payment_T
FOR UPDATE AS IF UPDATE(PaymentAmount)
BEGIN
INSERT INTO PaymentUpdates_Log(PaymentID, PaymentType, OldPaymentAmount, NewPaymentAmount, updatedate)
SELECT inserted.PaymentID, inserted.paymenttype, deleted.paymentamount, inserted.paymentamount, GETDATE() from inserted, deleted where inserted.paymentid = deleted.paymentid
END

UPDATE Payment_T SET paymentamount= 250 WHERE PaymentID= 105
UPDATE Payment_T SET paymentamount= 1000 WHERE PaymentID= 106

SELECT * FROM PaymentUpdates_Log

/* ---- END PaymentUpdate TRIGGER ----  */