SET FEEDBACK ON;
-- I'll use IDs that are likely not taken or higher than current MAX
-- Current IDs seem low (1-100).
-- Let's check max ID
VARIABLE next_ticket NUMBER;
VARIABLE next_booking NUMBER;
BEGIN
  SELECT NVL(MAX(TICKETID), 0) + 999 INTO :next_ticket FROM TICKET;
  SELECT NVL(MAX(BOOKINGID), 0) + 999 INTO :next_booking FROM BOOKING;
  
  -- Insert a Pending ticket (Seat 579 was returned above)
  -- Ensure the seat is available (delete if exists)
  DELETE FROM BOOKING_TICKET WHERE TICKETID IN (SELECT TICKETID FROM TICKET WHERE SEATID = 579 AND TICKETSTATUS != 'Cancelled');
  DELETE FROM TICKET WHERE SEATID = 579 AND TICKETSTATUS != 'Cancelled';
  
  INSERT INTO TICKET (TICKETID, TICKETPRICE, TICKETSTATUS, SEATID) 
  VALUES (:next_ticket, 300, 'Pending', 579);
  
  -- New Booking for show 1 (March 17th Morning)
  INSERT INTO BOOKING (BOOKINGID, BOOKINGDATE, USERID, SHOWID)
  VALUES (:next_booking, SYSDATE, 1, 1);
  
  -- Map them
  INSERT INTO BOOKING_TICKET (BOOKINGID, TICKETID)
  VALUES (:next_booking, :next_ticket);
  
  COMMIT;
END;
/
EXIT;
