      SUBROUTINE PUSH (IN,BCD,ICOL,NCHAR,FLAG)        
C        
C     THIS ROUTINE IS USED TO PLACE BCD CHARACTERS OR INTEGERS FROM II  
C     ARRAY INTO THE BCD STRING . IF FLAG = 1 AN INTEGER IS INPUT       
C        
      EXTERNAL        ORF        
      LOGICAL         FIRST        
      INTEGER         ORF,FLAG,BCD(1),CPERWD,IN(1),II(18),BLANK,        
     1                DIGIT,NUMBS(10)        
      CHARACTER       UFM*23        
      COMMON /XMSSG / UFM        
      COMMON /SYSTEM/ ISYS,IOUT,NOGO,IDUM(35),NBPC,NBPW,NCPW        
      DATA    NUMBS / 1H0,1H1,1H2,1H3,1H4,1H5,1H6,1H7,1H8,1H9 /        
      DATA    CPERWD/ 4 /, FIRST / .TRUE. /, BLANK /1H  /,        
     1        MINUS / 4H-   /        
C        
      IF (.NOT.FIRST) GO TO 15        
      FIRST = .FALSE.        
C        
C     REMOVE BLANKS FROM NUMBERS, AND ZERO FILL        
C        
      ISH   = NCPW - 1        
      DO 5 I = 1,10        
      ISAVE = KRSHFT(NUMBS(I),ISH)        
      NUMBS(I) = KLSHFT(ISAVE,ISH)        
    5 CONTINUE        
      ISAVE = KRSHFT(MINUS,ISH)        
      MINUS = KLSHFT(ISAVE,ISH)        
      NX    = NCPW - CPERWD        
      IXTRA = NX*NBPC        
      IBL   = 0        
      IF (NX .EQ. 0) GO TO 15        
      IB1   = KRSHFT(BLANK,ISH)        
      DO 10 I = 1,NX        
      IBL   = ORF(IBL,KLSHFT(IB1,I-1))        
   10 CONTINUE        
C        
   15 IF (NCHAR .LE. 0) RETURN        
      IF (NCHAR+ICOL .GT. 128) GO TO 70        
      NIN   = (NCHAR-1)/CPERWD + 1        
      DO 20 I = 1,NIN        
   20 II(I) = IN(I)        
      IF (FLAG .NE. 1) GO TO 50        
C        
C     INTEGER HAS BEEN INPUT - 1 WORD ONLY        
C        
C     FIND POWER OF 10 = NUMBER OF CHARACTERS        
C        
      IX    = IABS(IN(1))        
      DO 25 I = 1,8        
      IX    = IX/10        
      IF (IX .EQ. 0) GO TO 30        
   25 CONTINUE        
      GO TO 80        
   30 IC    = I        
      IF (IN(1) .LT.  0) IC = IC + 1        
      IF (IC .GT. NCHAR) GO TO 80        
      II(2) = BLANK        
      IX    = IABS(IN(1))        
      IF (IC .LE. CPERWD) GO TO 40        
C        
C     NUMBER TAKES TWO WORDS        
C        
      M     = IC - CPERWD        
      II(2) = KRSHFT(BLANK,M)        
      DO 35 I = 1,M        
      IJ    = IX/10        
      DIGIT = IABS(IX-10*IJ) + 1        
      IX    = IJ        
      IADD  = NUMBS(DIGIT)        
      II(2) = ORF(II(2),KRSHFT(IADD,M-I))        
   35 CONTINUE        
C        
      IC    = CPERWD        
C        
C     FIRST WORD SET HERE FOR BOTH CASES        
C        
   40 II(1) = KRSHFT(BLANK,IC)        
      DO 45 I = 1,IC        
      IF (I.EQ.IC .AND. IN(1).LT.0) GO TO 45        
      IJ    = IX/10        
      DIGIT = IABS(IX-10*IJ) + 1        
      IX    = IJ        
      IADD  = NUMBS(DIGIT)        
      II(1) = ORF(II(1),KRSHFT(IADD,IC-I))        
   45 CONTINUE        
      IF (IN(1) .LT. 0) II(1) = ORF(II(1),MINUS)        
C        
   50 IWRD  = (ICOL-1)/CPERWD + 1        
      ICL   = ICOL - (IWRD-1)*CPERWD        
      LWRD  = (ICOL+NCHAR-2)/CPERWD + 1        
      LCOL  = ICOL + NCHAR - (LWRD-1)*CPERWD - 1        
      M1    = (ICL-1)*NBPC        
      M2    = CPERWD*NBPC - M1        
      M3    = M2 + (NCPW-CPERWD)*NBPC        
C        
C     M1 IS THE NUMBER OF BITS FOR THE  FIRST SET OF CHARACTERS        
C     M2 IS THE NUMBER OF BITS FOR THE SECOND SET OF CHARACTERS        
C     M3 IS THE NUMBER OF BITS FOR THE RIGHT HALF OF THE WORD        
C        
C     IADD IS THE CURRENT WORKING WORD, IADD1 IS THE SPILL        
C        
      ISAVE = KRSHFT(BCD(IWRD),M3/NBPC)        
      IADD1 = KLSHFT(ISAVE,M3/NBPC)        
      K = 0        
      DO 60 I = IWRD,LWRD        
      K = K + 1        
C        
C     SPLIT INPUT WORD INTO TWO SETS        
C        
C     MOVE LEFT HALF TO RIGHT SIDE OF IADD AND ADD IADD1        
C        
      ISAVE = KRSHFT(II(K),(M1+IXTRA)/NBPC)        
      IADD  = ORF(KLSHFT(ISAVE,IXTRA/NBPC),IADD1)        
C        
C     IF THIS ISNT THE LAST WORD MOVE THE RIGHT HALF TO IADD1 AND INSERT
C        
      IF (I .GE. LWRD) GO TO 60        
      ISAVE = KRSHFT(II(K),IXTRA/NBPC)        
      IADD1 = KLSHFT(ISAVE,M3/NBPC)        
C        
      BCD(I) = ORF(IADD,IBL)        
C        
   60 CONTINUE        
C        
C     LAST WORD PROCESSED HERE, REMOVE EXTRA CHARACTERS        
C        
      ISH   = NCPW - LCOL        
      ISAVE = KRSHFT(IADD ,ISH)        
      IADD  = KLSHFT(ISAVE,ISH)        
      ISAVE = KLSHFT(BCD(LWRD),LCOL)        
      BCD(LWRD) = ORF(IADD,KRSHFT(ISAVE,LCOL))        
      RETURN        
C        
   70 WRITE  (IOUT,75) UFM,NCHAR,IN        
   75 FORMAT (A23,' 6015. TOO MANY CHARACTERS TO BE INSERTED IN A DMAP',
     1       ' LINE', /6X,4H N = , I8 ,6X, 6HWORD =,A4)        
      GO TO 90        
   80 WRITE  (IOUT,85) UFM,IN        
   85 FORMAT (A23,' 6016. TOO MANY DIGITS TO BE INSERTED IN DMAP.',     
     1       2X,'VALUE =',I12)        
C        
   90 NOGO = 1        
      RETURN        
      END        
