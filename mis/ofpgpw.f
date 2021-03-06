      SUBROUTINE OFPGPW (*,FILE,OUT,FROM)        
C        
C     PRINT GRID POINT WEIGHT GENERATORN TABLE        
C     (SOURCE PROGRAM ORIGINALLY CODED IN OFP)        
C        
      INTEGER          FILE,FLAG,FROM,OF(5)        
      DOUBLE PRECISION OUT(1)        
      COMMON /SYSTEM/  IBUF,L,DUMMY(10),LINE        
CZZ   COMMON /ZZOFPX/  CORE(1)        
      COMMON /ZZZZZZ/  CORE(1)        
      EQUIVALENCE      (L1,OF(1),CORE(1)), (L2,OF(2)), (L3,OF(3)),      
     1                 (L4,OF(4)), (L5,OF(5))        
C        
C     FOR GRIDPOINT WEIGHT OUTPUT ONLY ONE DATA VECTOR OF 78 WORDS      
C     IS EXPECTED AND IT IS THUS READ AND OUTPUT EXPLICITLY        
C     (CHANGED TO D.P. BY G.CHAN/UNISYS, AND THEREFORE 156 WORDS.       
C     THIS RECORD IS SENT OVER BY GPWG1B, WHICH IS NOW A D.P. ROUTINE)  
C        
      FROM = 345        
      CALL READ (*2020,*60,FILE,OUT(1),90,0,FLAG)        
      L1 = 0        
      L2 = 0        
      L3 = 202        
      L4 = 0        
      L5 = 0        
      CALL OFP1        
      LINE = LINE + 44        
      WRITE  (L,350) (OUT(I),I=1,45)        
  350 FORMAT (37X,        
     1       'MO - RIGID BODY MASS MATRIX IN BASIC COORDINATE SYSTEM',  
     2       /16X,3H***,93X,3H***, /6(16X,1H*,1P,6D16.8,2H *,/),16X,    
     3       3H***,93X,3H***, /40X,        
     4       51HS - TRANSFORMATION MATRIX FOR SCALAR MASS PARTITION,    
     5       /2(40X,3H***,5X), /3(40X,1H*,1P,3D16.8,2H *,/),2(40X,3H***,
     4       5X),  /25X,9HDIRECTION, /20X,20HMASS AXIS SYSTEM (S),7X,   
     5       4HMASS,17X,6HX-C.G.,11X,6HY-C.G.,11X,6HZ-C.G.)        
      FROM = 355        
      CALL READ (*2020,*60,FILE,OUT(1),66,1,FLAG)        
      WRITE  (L,360) (OUT(I),I=1,12)        
  360 FORMAT (28X,1HX,1P,D27.9,1P,D21.9,1P,2D17.9,/        
     1        28X,1HY,1P,D27.9,1P,D21.9,1P,2D17.9,/        
     2        28X,1HZ,1P,D27.9,1P,D21.9,1P,2D17.9)        
      WRITE  (L,370) (OUT(I),I=13,33)        
  370 FORMAT (/49X,33HI(S) - INERTIAS RELATIVE TO C.G. , /2(38X,3H***,  
     1       11X), /3(38X,1H*,1P,3D17.9,3H  *,/),2(38X,3H***,11X), /54X,
     2       25HI(Q) - PRINCIPAL INERTIAS, /2(38X,3H***,11X), /38X,1H*, 
     3       1P,D17.9,36X,1H*, /38X,1H*,1P,D34.9,19X,1H*, /38X,1H*,1P,  
     4       D51.9,3H  *, /2(38X,3H***,11X), /44X,        
     5       44HQ - TRANSFORMATION MATRIX - I(Q) = QT*I(S)*Q, /2(38X,   
     6       3H***,11X),/3(38X,1H*,1P,3D17.9,3H  *,/),2(38X,3H***,11X)) 
  60  RETURN        
C        
 2020 RETURN 1        
      END        
