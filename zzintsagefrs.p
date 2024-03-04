/******************************************************************************/
/* Program name  : zzintsagefrs.p                                             */
/* Title         : Interface factures fournisseur                             */
/*                                                                            */
/* Purpose       : Interface factures fournisseur pour exporter vers sage     */
/*                                                                            */
/* Author        :                                                            */
/* Creation date : 11/08/23                                                   */
/* ECO #         :                                                            */
/* Model         : QAD EE                                                     */
/******************************************************************************/
/* (c) copyright CSI, unpublished work                                        */
/* this computer program includes confidential, proprietary information       */
/* and is a trade secret of CSI                                               */
/* all use, disclosure, and/or reproduction is prohibited unless authorized   */
/* in writing. all rights reserved.                                           */
/******************************************************************************/
/*v8:convertmode=report                                                       */
/*----------------------------------------------------------------------------*/
/*  Modif.       ! Auteur ! Date     ! Commentaires                           */
/*---------------!--------!----------!----------------------------------------*/
/*  2020-SAGE    !  AL    ! 31/08/23 ! Creation                               */
/******************************************************************************/

{us/mf/mfdtitle.i}

/*******************************************************************************
__      __        _       _     _
\ \    / /       (_)     | |   | |
 \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___
  \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
   \  / (_| | |  | | (_| | |_) | |  __/\__ \
    \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/                          VARIABLES
*******************************************************************************/
define variable v_entity_from        as character   format "x(30)"              no-undo.
define variable v_entity_to          as character   format "x(30)"              no-undo.
define variable v_piece_from         as character   format "x(30)"              no-undo.
define variable v_piece_to           as character   format "x(30)"              no-undo.
define variable v_four_from          as character   format "x(30)"              no-undo.
define variable v_four_to            as character   format "x(30)"              no-undo.
define variable v_datef_from         like CInvoice.CInvoiceDueDate              no-undo.
define variable v_datef_to           like CInvoice.CInvoiceDueDate              no-undo.
define variable v_datev_from         like CInvoice.CInvoiceDueDate              no-undo.
define variable v_datev_to           like CInvoice.CInvoiceDueDate              no-undo.
define variable v_rexp               as logical     initial  no                 no-undo.
define variable v_file               as character  format "x(60)"               no-undo.
define variable v_file_name          as character  format "x(40)"               no-undo.
define variable v_op_path            as character  format "x(40)"               no-undo.
define variable v_file_sp            as character initial ";"                   no-undo.
define variable v_rexport            as     logical   initial  no               no-undo.
define variable v_postingdate_from   like CInvoice.CInvoicePostingDate          no-undo.
define variable v_postingdate_to     like CInvoice.CInvoicePostingDate          no-undo.

define stream file_csv.


/*******************************************************************************
 _______                      _______    _     _
|__   __|                    |__   __|  | |   | |
   | | ___ _ __ ___  _ __ ______| | __ _| |__ | | ___  ___
   | |/ _ \ '_ ` _ \| '_ \______| |/ _` | '_ \| |/ _ \/ __|
   | |  __/ | | | | | |_) |     | | (_| | |_) | |  __/\__ \
   |_|\___|_| |_| |_| .__/      |_|\__,_|_.__/|_|\___||___/
                  | |
                  |_|                                             TEMP-TABLES
*******************************************************************************/
define temp-table tt_output
   field field_1  as character
   field field_2  as character
   field field_3  as character
   field field_4  as character
   field field_5  as character format "x(30)"
   field field_6  as character
   field field_7  as character
   field field_8  as character
   field field_9  as character format "x(30)"
   field field_10 as character format "x(30)"
   field field_11 as character
   field field_12 as character
   field field_13 as character
   field field_14 as character
   field field_15 as character
   field field_16 as character
   field field_17 as character format "x(30)"
   field field_18 as character
   field field_19 as character
   field field_20 as character
   field field_21 as character
   field field_22 as integer
   field field_23 as decimal
.


/*******************************************************************************
______
|  ____|
| |__ _ __ __ _ _ __ ___   ___  ___
|  __| '__/ _` | '_ ` _ \ / _ \/ __|
| |  | | | (_| | | | | | |  __/\__ \
|_|  |_|  \__,_|_| |_| |_|\___||___/                                     FRAMES
*******************************************************************************/
Form 
   v_entity_from      colon 12 label "Entite"
   v_entity_to        colon 47 label "A"
   v_piece_from       colon 12 label "Piece"
   v_piece_to         colon 47 label "A"
   v_four_from        colon 12 label "Fournisseur"
   v_four_to          colon 47 label "A"
   v_datef_from       colon 27 label "Date facturation"
   v_datef_to         colon 47 label "A"
   v_datev_from       colon 27 label "Date validite"
   v_datev_to         colon 47 label "A"
   v_postingdate_from colon 27 label "Date comptabilisation"
   v_postingdate_to   colon 47 label "A"
   v_rexp             colon 27 label "Réexporter"
   skip(1) // LINE BREAK
   v_file_name        colon 20 label "Fichier"
   v_op_path          colon 20 label "Dossier"
   /*v_file             colon 20 label "LIEN de L'EXPORT"*/

with Frame a side-labels width 80. 

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SET EXTERNAL LABELS */
form
with frame reprint_frame down width 400.
/* SET EXTERNAL labelS */
setframelabels(frame reprint_frame:handle).

/******************************************************************************
 _____        _ _  _       _ _
|_   _|     (_) | (_)     | (_)
  | |  _ __  _| |_ _  __ _| |_ _______
  | | | '_ \| | __| |/ _` | | |_  / _ \
 _| |_| | | | | |_| | (_| | | |/ /  __/
|_____|_| |_|_|\__|_|\__,_|_|_/___\___|                              INITIALIZE
*******************************************************************************/
assign
   v_entity_from = current_entity
   v_entity_to   = current_entity
.

/***************************************************************************************************
 ______               _   _
|  ____|             | | (_)
| |__ ___  _ __   ___| |_ _  ___  _ __  ___
|  __/ _ \| '_ \ / __| __| |/ _ \| '_ \/ __|
| | | (_) | | | | (__| |_| | (_) | | | \__ \
|_|  \___/|_| |_|\___|\__|_|\___/|_| |_|___/                                             FONCTIONS
***************************************************************************************************/
FUNCTION F_get_gn_parm returns character (input ip_fldname as character, 
                                       input ip_value   as character ):
      define variable v_path as character no-undo.

      v_path = "" .

      find first code_mstr 
           where code_domain   = global_domain
             and code_fldname  = ip_fldname
             and code_value    = "Yes"
      no-lock no-error.

      if available code_mstr then do : 
         v_path = code_cmmt + "/".
         return v_path.
      end. 
      else
         return v_path.
END FUNCTION.  /* F_get_gn_parm */  


Function P_Combinations  returns decimal (input  v-total   as decimal, 
                                          input  v-sum     as decimal, 
                                          input  v-index   as int,
                                          input  field_22 as int, 
                                          input  field_17 as char ):

   define buffer bf1_tt_output for tt_output.
   define buffer bff_tt_output for tt_output.


   define variable v-diff as decimal no-undo.
   define variable v-count as decimal no-undo.
   define variable i as int no-undo.
   define variable v-len as int no-undo.


   for each bf1_tt_output 
   where bf1_tt_output.field_22 = field_22 
   and bf1_tt_output.field_4 = "G"
   and (bf1_tt_output.field_17 = ""  or  bf1_tt_output.field_17 = "-" )  :
       v-len = v-len + 1.
   end.


   if v-total = v-sum or v-total = (v-sum + 0.02) or v-total = (v-sum - 0.02) then do:
      for each bff_tt_output where tt_output.field_22 = field_22
      and bff_tt_output.field_17 = "-" :
         bff_tt_output.field_17 = field_17.
      end. 

      return 0.
   end.

   if v-index = 5000 then leave.

   v-count = 0.
   i = 0 .

   for each bf1_tt_output 
   where bf1_tt_output.field_22 = field_22 
   and bf1_tt_output.field_4 = "G"
   and (bf1_tt_output.field_17 = ""  or  bf1_tt_output.field_17 = "-" ) :

      if i >= (v-index) and i <= v-len then do:
         
         bf1_tt_output.field_17 = "-" .
         if bf1_tt_output.field_14 = "C"
         then do: 
            v-diff = v-sum - decimal(bf1_tt_output.field_15) .
            v-count = v-count + P_Combinations(v-total, v-sum - decimal(bf1_tt_output.field_15) , i + 1, field_22, field_17).
         /*v-total-va = v-sum - decimal(bf1_tt_output.field_15) .*/
         end.
         else do: 
            v-diff = v-sum + decimal(bf1_tt_output.field_15) .
            v-count = v-count + P_Combinations(v-total, v-sum + decimal(bf1_tt_output.field_15) , i + 1, field_22, field_17).
         /*v-total-va = v-total-va + decimal(bf1_tt_output.field_15) .*/
         end.



      end.

      i = i + 1 .

   end.

   for each bf1_tt_output 
   where bf1_tt_output.field_22 = field_22 
   and bf1_tt_output.field_4 = "G"
   and bf1_tt_output.field_17 = "-"  :
       bf1_tt_output.field_17 = "" .
   end.
   
   return v-count.
   
END FUNCTION .


/***********
function F_Date_Format returns character (input ip_date as date) :              
                                                                           
   define variable v_date  as character no-undo.   
   define variable v_month   as character no-undo.

   if length(month(ip_date)) < 2 
   then  v_month = "0" + string(month(ip_date)).
   else  v_month = string(month(ip_date)).

   v_date = string(day(ip_date)) + "" +                                            
            v_month + "" +                                 
            substring(string(year(ip_date)), 3 , 2 )
         .  

   return v_date .   
                  
                                                
END FUNCTION. /*F_Date_Format*/
***********/

function F_Date_Format returns character (input ip_date as date) :              
                                                                        
   define variable v_date    as character no-undo.   
   define variable v_month   as character no-undo.
   define variable v_day     as character no-undo.

   if   length(month(ip_date)) < 2 
   then  v_month = "0" + string(month(ip_date)).
   else  v_month = string(month(ip_date)).

   if   length(day(ip_date)) < 2 
   then  v_day = "0" + string(day(ip_date)).
   else  v_day = string(day(ip_date)).


   v_date = v_day   + "" +                                            
            v_month + "" +                                 
            substring(string(year(ip_date)), 3 , 2 )
         .  
   return v_date .   
                                                        
END FUNCTION. /*F_Date_Format*/

/*******************************************************************************
 __  __          _____ _   _ _      ____   ____  _____
|  \/  |   /\   |_   _| \ | | |    / __ \ / __ \|  __ \
| \  / |  /  \    | | |  \| | |   | |  | | |  | | |__) |
| |\/| | / /\ \   | | | . ` | |   | |  | | |  | |  ___/
| |  | |/ ____ \ _| |_| |\  | |___| |__| | |__| | |
|_|  |_/_/    \_\_____|_| \_|______\____/ \____/|_|                    MAINLOOP
*******************************************************************************/
mainloop:
repeat:


   empty temp-table tt_output.

   if v_entity_to   = hi_char then v_entity_to   = "" .
   if v_piece_to   = hi_char then v_piece_to   = "" .
   if v_four_to   = hi_char then v_four_to   = "" .

   if v_datef_from   = low_date then v_datef_from   = ? .
   if v_datef_to   = hi_date then v_datef_to    = ? .
   if v_datev_from   = low_date then v_datev_from   = ? .
   if v_datev_to   = hi_date then v_datev_to    = ? .
   if v_postingdate_from = low_date then v_postingdate_from = ?.
   if v_postingdate_to = hi_date then v_postingdate_to = ?.


   display
      v_file_name
      v_op_path
      /*v_file*/
   with frame a.
   
   update 
      v_entity_from     
      v_entity_to       
      v_piece_from      
      v_piece_to        
      v_four_from       
      v_four_to         
      v_datef_from
      v_datef_to
      v_datev_from
      v_datev_to
      v_postingdate_from
      v_postingdate_to
      v_rexp
   with frame a.

   assign
      v_op_path = ""
      v_file = "Pur_Interface_Sage_"
               + string(day(today),"99")                
               + string(month(today),"99")              
               + string(year(today),"9999")             
               + substring(string(time,"HH:MM:SS"),1,2) 
               + substring(string(time,"HH:MM:SS"),4,2) 
               + substring(string(time,"HH:MM:SS"),7,2) 
               + ".txt"
       v_file_name = v_file
   .

   if v_entity_to  = ""  then v_entity_to  = hi_char  .
   if v_piece_to  = ""  then v_piece_to  = hi_char  .
   if v_four_to  = ""  then v_four_to  = hi_char  .

   if v_datef_from   = ? then v_datef_from   = low_date .
   if v_datef_to   = ? then v_datef_to    = hi_date .
   if v_datev_from   = ? then v_datev_from   = low_date .
   if v_datev_to   = ? then v_datev_to    = hi_date .
   if v_postingdate_from = ? then v_postingdate_from = low_date.
   if v_postingdate_to = ? then v_postingdate_to = hi_date.


   v_op_path = F_get_gn_parm("Sage_Pur_Inter" , "Yes" ).

   if (v_op_path = "") then do:
      {us/bbi/pxmsg.i &MSGNUM=99158 &ERRORLEVEL=4}.
      next-prompt v_rexport with frame main_frame.
      undo mainloop, retry mainloop.
   end.

   v_file =  v_op_path + v_file  .

   if v_rexp = yes then run search_data(input "exp").
   else 
      run search_data(input "").

end.


procedure write_csv:

define buffer b_tt_output for tt_output.
   define buffer b2_tt_output for tt_output.
   define buffer bbb_tt_output for tt_output.
   define var v-total-vat as decimal no-undo.
   define var v-res as int no-undo.
   define variable v_is_empty as logical initial no no-undo.

   
   output stream file_csv to value (v_file) append.
   for each tt_output 
   break by field_22
   :

      IF FIRST-OF(tt_output.field_22) then do:



      for each b_tt_output where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 = "V" and b_tt_output.field_17 <> "" and b_tt_output.field_14 = "D" :
         
         define var a as decimal.
         a = 1.
         do while a <> 0 :
            v-total-vat = 0 .
            v-res = 1.
            a = 1.
         
            for each b2_tt_output where b2_tt_output.field_22 = b_tt_output.field_22
            and b2_tt_output.field_17 = b_tt_output.field_17 and  b2_tt_output.field_4 = "G":

               if b2_tt_output.field_14 = "D" then
                  v-total-vat = v-total-vat + decimal(b2_tt_output.field_15).
               else 
                  v-total-vat = v-total-vat - decimal(b2_tt_output.field_15).


            end.

            if (v-total-vat = b_tt_output.field_23) then do:
               /*b2_tt_output.field_17 = b_tt_output.field_17.*/
               a = 0.
               next.
            end.
            else  do:
               a = P_Combinations(b_tt_output.field_23 - v-total-vat , v-total-vat , 0 , b_tt_output.field_22 , b_tt_output.field_17).
            end.
         end.
         
        /*a =  P_Combinations( decimal(b_tt_output.field_23) , decimal(0) , 0 , b_tt_output.field_22 , b_tt_output.field_17).
        message a.*/

      end.



      for each b_tt_output 
      where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 = "G" :

         for each b2_tt_output 
         where b_tt_output.field_22 = b2_tt_output.field_22
         and b2_tt_output.field_1 = b_tt_output.field_1
         and b2_tt_output.field_2 = b_tt_output.field_2
         and b2_tt_output.field_3 = b_tt_output.field_3
         and b2_tt_output.field_5 = b_tt_output.field_5
         and b2_tt_output.field_4 = "A"
         and b2_tt_output.field_7 = b_tt_output.field_7
         and b2_tt_output.field_8 = b_tt_output.field_8
         and b2_tt_output.field_9 = b_tt_output.field_9
         and b2_tt_output.field_10 = b_tt_output.field_10
         and b2_tt_output.field_11 = b_tt_output.field_11
         and b2_tt_output.field_12 = b_tt_output.field_12
         and b2_tt_output.field_13 = b_tt_output.field_13
         and b2_tt_output.field_14 = b_tt_output.field_14
         and b2_tt_output.field_15 = b_tt_output.field_15
         and b2_tt_output.field_16 = b_tt_output.field_16
         and b2_tt_output.field_18 = b_tt_output.field_18
         and b2_tt_output.field_19 = b_tt_output.field_19
         and b2_tt_output.field_20 = b_tt_output.field_20 :

         b2_tt_output.field_17 = b_tt_output.field_17.

      end.
      end.

      /*check if there is an empty TVA_PROFILE .*/
      

      for each b_tt_output 
      where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 <> "V" 
      and b_tt_output.field_4 <> "X":
         /*
         run P_Flag_INV_EMP_fl_17( input b_tt_output.field_9 ,
                                output v_is_empty ).

      if v_is_empty = no then do :
         v_file = replace(v_file,"_error.txt",".txt").
      end.
      else do :
         v_file = replace(v_file,"_error.txt",".txt").
         v_file = replace(v_file,".txt","_error.txt").
      end.*/

         put stream file_csv unformatted 
         b_tt_output.field_1    v_file_sp
         b_tt_output.field_2    v_file_sp
         b_tt_output.field_3    v_file_sp
         b_tt_output.field_4    v_file_sp
         b_tt_output.field_5    v_file_sp
         b_tt_output.field_6    v_file_sp
         b_tt_output.field_7    v_file_sp
         b_tt_output.field_8    v_file_sp
         b_tt_output.field_9    v_file_sp
         b_tt_output.field_10   v_file_sp
         b_tt_output.field_11   v_file_sp
         b_tt_output.field_12   v_file_sp
         b_tt_output.field_13   v_file_sp
         b_tt_output.field_14   v_file_sp
         b_tt_output.field_15   v_file_sp
         b_tt_output.field_16   v_file_sp
         b_tt_output.field_17   v_file_sp
         b_tt_output.field_18   v_file_sp
         b_tt_output.field_19   v_file_sp
         b_tt_output.field_20   v_file_sp
         b_tt_output.field_21     
         skip.
         
      end.

      for each b_tt_output 
      where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 = "V"
      and decimal(b_tt_output.field_19) <> 0  :

         put stream file_csv unformatted 
         b_tt_output.field_1    v_file_sp
         b_tt_output.field_2    v_file_sp
         b_tt_output.field_3    v_file_sp
         "G"                    v_file_sp
         b_tt_output.field_5    v_file_sp
         b_tt_output.field_6    v_file_sp
         b_tt_output.field_7    v_file_sp
         b_tt_output.field_8    v_file_sp
         b_tt_output.field_9    v_file_sp
         b_tt_output.field_10   v_file_sp
         b_tt_output.field_11   v_file_sp
         b_tt_output.field_12   v_file_sp
         b_tt_output.field_13   v_file_sp
         b_tt_output.field_14   v_file_sp
         b_tt_output.field_15   v_file_sp
         b_tt_output.field_16   v_file_sp
         b_tt_output.field_17   v_file_sp
         b_tt_output.field_18   v_file_sp
         b_tt_output.field_19   v_file_sp
         b_tt_output.field_20   v_file_sp
         b_tt_output.field_21      
         skip.
         
      end.
 
      for each b_tt_output 
      where b_tt_output.field_22 = tt_output.field_22
      and b_tt_output.field_4 = "X":

      
         put stream file_csv unformatted 
         b_tt_output.field_1    v_file_sp
         b_tt_output.field_2    v_file_sp
         b_tt_output.field_3    v_file_sp
         b_tt_output.field_4    v_file_sp
         b_tt_output.field_5    v_file_sp
         b_tt_output.field_6    v_file_sp
         b_tt_output.field_7    v_file_sp
         b_tt_output.field_8    v_file_sp
         b_tt_output.field_9    v_file_sp
         b_tt_output.field_10   v_file_sp
         b_tt_output.field_11   v_file_sp
         b_tt_output.field_12   v_file_sp
         b_tt_output.field_13   v_file_sp
         b_tt_output.field_14   v_file_sp
         b_tt_output.field_15   v_file_sp
         b_tt_output.field_16   v_file_sp
         b_tt_output.field_17   v_file_sp
         b_tt_output.field_18   v_file_sp
         b_tt_output.field_19   v_file_sp
         b_tt_output.field_20   v_file_sp 
         b_tt_output.field_21      
         skip.
         
      end.



   end.
   end.


   output stream file_csv close.
   empty temp-table tt_output.

end.



procedure compute :

   define input parameter field_22 as int no-undo.
   define input parameter field_23 as decimal no-undo.
   define input parameter field_15 as char no-undo.
   define input parameter field_17 as char no-undo.
   define input parameter v-total-va as decimal no-undo.
   define input parameter v-res as int no-undo.
   define variable v-counter as int no-undo.
   define variable v-max as int no-undo.
   define variable v-rows as int no-undo.
   define variable v-i as int no-undo.
   define variable v-diff as decimal no-undo.
   define variable v-first-total as decimal no-undo.
   define buffer bf1_tt_output for tt_output.
   define buffer bff_tt_output for tt_output.


   for each bf1_tt_output 
   where bf1_tt_output.field_22 = field_22 
   and bf1_tt_output.field_4 = "G"
   and bf1_tt_output.field_17 = "":
       v-rows = v-rows + 1.
   end.

   v-max = v-rows + 1 .
   for each bf1_tt_output 
   where bf1_tt_output.field_22 = field_22 
   and bf1_tt_output.field_4 = "G"
   and bf1_tt_output.field_17 = "":
       v-max = v-max + (v-rows - 1).
   end.


   

   for each bf1_tt_output 
   where bf1_tt_output.field_22 = field_22 
   and bf1_tt_output.field_4 = "G"
   and bf1_tt_output.field_17 = "" :
      
      
      if v-counter = v-res - 1  then do:
         v-counter = v-counter + 1.
         next.
      end.
         
      if v-counter < (v-res - v-rows)  then do:
         v-counter = v-counter + 1.
         next.
      end.

      /*AC*/
      if bf1_tt_output.field_14 = "C"
      then do: 
         v-diff = field_23 - (v-total-va - decimal(bf1_tt_output.field_15)) .
         v-total-va = v-total-va - decimal(bf1_tt_output.field_15) .
      end.
      else do: 
         v-diff = field_23 - (v-total-va + decimal(bf1_tt_output.field_15)) .
         v-total-va = v-total-va + decimal(bf1_tt_output.field_15) .
      end.


      bf1_tt_output.field_17 = "-" .

      if v-diff = 0 or v-diff = 0.02 or v-diff = - 0.02 then do:

         bf1_tt_output.field_17 = field_17.

         for each bff_tt_output where tt_output.field_22 = field_22
         and bff_tt_output.field_17 = "-" :
            bff_tt_output.field_17 = field_17.
         end. 

         /*for each bff_tt_output where tt_output.field_22 = field_22
         and bff_tt_output.field_17 = "" and bff_tt_output.field_4 = "A" and bff_tt_output.field_3 = bf1_tt_output.field_3:
            bff_tt_output.field_17 = field_17.
         end. */
         v-res = 0.

         
         leave.

      end.


      else if v-diff > 0.02 then do:

         bf1_tt_output.field_17 = "-" .
         next.
         
      end.

      
      else if v-diff < - 0.02 then do:
         bf1_tt_output.field_17 = "-" .
         next.
         
      end.

      v-counter = v-counter + 1.

   end.

   if (v-res <> 0 ) then do:
      for each bff_tt_output where bff_tt_output.field_22 = field_22
         and bff_tt_output.field_17 = "-" :
            bff_tt_output.field_17 = "".
      end. 
      if (v-res) <= (v-max)  then
      run compute (input field_22,input decimal(field_23),input field_15,input field_17,input 0,input v-res + 1).

      //run compute (input field_22,input field_23,input field_15,input field_17,input v-total-va,input v-res + 1).
   end.


end.

procedure add_row :

   define input parameter i_arr_line as character extent 23.
   

   create tt_output.

   tt_output.field_1  = i_arr_line[1].
   tt_output.field_2  = i_arr_line[2].
   tt_output.field_3  = i_arr_line[3].
   tt_output.field_4  = i_arr_line[4].
   tt_output.field_5  = i_arr_line[5].
   tt_output.field_6  = i_arr_line[6].
   tt_output.field_7  = i_arr_line[7].
   tt_output.field_8  = i_arr_line[8].
   tt_output.field_9  = i_arr_line[9].
   tt_output.field_10 = i_arr_line[10].
   tt_output.field_11 = i_arr_line[11].
   tt_output.field_12 = i_arr_line[12].
   tt_output.field_13 = i_arr_line[13].
   tt_output.field_14 = i_arr_line[14].
   tt_output.field_15 = i_arr_line[15].
   tt_output.field_16 = i_arr_line[16].
   tt_output.field_17 = i_arr_line[17].
   tt_output.field_18 = i_arr_line[18].
   tt_output.field_19 = i_arr_line[19].
   tt_output.field_20 = i_arr_line[20].
   tt_output.field_21 = i_arr_line[21].
   tt_output.field_22  = decimal(i_arr_line[22]).
   tt_output.field_23  = decimal(i_arr_line[23]).
 

end.



PROCEDURE  P_Flag_INV_EMP_fl_17:
   define input  parameter ip_field_9 as character no-undo.
   define output parameter op_Is_empty as logical initial no no-undo. 

   for first tt_output 
   where field_9 = ip_field_9
   and field_4   = "G"
   and field_17 = "" :

      op_Is_empty = yes.

   end. /*for each tt_output*/


END PROCEDURE. /*P_Flag_INV_EMP_fl_17*/

procedure search_data :

   define variable arr as character extent.
   define variable v_subaccount as character.
   define variable v_currency_code as character.
   define variable file_name as character.
   define variable arr_line as character extent 23.
   define variable num_line as integer initial 0.
   define input parameter i_exp as character.
   define buffer zz_cinvoice for CInvoice.
   define buffer xx_cinvoice for Cinvoice.
   define buffer d_cinvoice for tt_output.


   define variable voucher_f as int.
   define variable voucher_t as int.

   define variable date_f as int.
   define variable date_t as int.

   define variable journal_f as character.
   define variable journal_t as character.

   if NUM-ENTRIES( v_piece_from,"/") > 2 then do:
   assign
      voucher_f = integer(ENTRY(3,v_piece_from,"/"))
      voucher_t = integer(ENTRY(3,v_piece_to,"/"))

      date_f = integer(ENTRY(1,v_piece_from,"/"))
      date_t = integer(ENTRY(1,v_piece_to,"/"))

      journal_f = string(ENTRY(2,v_piece_from,"/"))
      journal_t = string(ENTRY(2,v_piece_to,"/"))
   .
   end.
   else do:
      assign
      voucher_f = 000000000
      voucher_t = 999999999

      date_f = 0000
      date_t = 9999

      journal_f = "A"
      journal_t = "ZZZZZZZZ"
      .
   end.


   for each CInvoice  exclusive-lock        

      
   where    CInvoice.CInvoiceVoucher       >=  voucher_f 
   and    CInvoice.CInvoiceVoucher       <=    voucher_t
   and    CInvoice.CInvoicePostingYear       >=  date_f
   and    CInvoice.CInvoicePostingYear       <=  date_t

   and CInvoice.CInvoiceDueDate     >=  v_datev_from
   and    CInvoice.CInvoiceDueDate     <=  v_datev_to
   and    CInvoice.CInvoiceDate        >=  v_datef_from
   and    CInvoice.CInvoiceDate        <=  v_datef_to
   and    CInvoice.CInvoicePostingDate >= v_postingdate_from
   and    CInvoice.CInvoicePostingDate <= v_postingdate_to
   and    Cinvoice.CustomCombo0        =    i_exp
   and    CInvoice.CInvoiceIsOpen      = yes
   and    (CInvoice.CInvoiceType = "CREDITNOTE" 
            OR CInvoice.CInvoiceType = "INVOICE")
   ,first  Creditor  no-lock
   where  Creditor.Creditor_ID   =   CInvoice.Creditor_ID  
   and    Creditor.CreditorCode  >=  v_four_from
   and    Creditor.CreditorCode  <=  v_four_to                                                     
   ,first  Company                               
   where  Company.Company_ID    =  CInvoice.Company_ID   
   and    Company.CompanyCode  >=  v_entity_from
   and    Company.CompanyCode  <=  v_entity_to  

   ,first  Reason                               
   where  Reason.Reason_ID    =  CInvoice.Reason_ID
   and Reason.ReasonCode <> "AP-PO-INITIAL"
   and Reason.ReasonCode <> "AP-NPO-INITIAL"
   ,first  Journal                               
   where  Journal.Journal_ID    =  CInvoice.Journal_ID
   and Journal.JournalCode >= journal_f
   and Journal.JournalCode <= journal_t
   no-lock:

      
      if  Cinvoice.CinvoiceType = "INVOICE" then do:
         if CInvoice.CInvoiceOriginalCreditTC = 0 then next.


         find first CInvoicePO where CInvoicePO.CInvoice_ID = Cinvoice.CInvoice_ID no-lock no-error.

         if available CInvoicePO then do:
               if CInvoice.CInvoiceIsLogisticMatching = no then do: 
                  next.
               end.
               else do:

                  find first  APMatching                               
                  where APMatching.CInvoice_ID   =  CInvoice.CInvoice_ID
                  and APMatching.APMatchingStatus = "FINISHEDAPMATCHING" 
                  no-lock no-error.
                  
                  if (available CInvoicePO) = no then do: 
                     next.
                  end.

               end.
         end.

         /*else do:
               if Reason.ReasonCode <> "AP-NPO-Alloc" then next.
         end.*/
         

            
      end.

      if  Cinvoice.CinvoiceType = "CREDITNOTE" then do:
         if CInvoice.CInvoiceOriginalDebitTC = 0 then next.
         find first zz_cinvoice where zz_cinvoice.CinvoiceType = "INVOICE" and zz_cinvoice.CInvoiceReference = Cinvoice.CInvoiceReference 
         and zz_cinvoice.CustomCombo0 = Cinvoice.CustomCombo0 no-lock no-error.

         if available zz_cinvoice then do:
               next.
         end.

      end.

      find first Division
      where Division.Division_ID = CInvoice.Division_ID 
      no-lock no-error.
      if available Division then v_subaccount = Division.DivisionCode. 

      find first Currency                                                      
      where CInvoice.CInvoiceCurrency_ID = Currency.Currency_ID   
      no-lock no-error. 
      if available Currency then v_currency_code = Currency.CurrencyCode.  
      define variable a as integer initial 0  no-undo.
      define variable b as character  initial "" no-undo.

      

      num_line = num_line + 1.

      for each CInvoicePosting no-lock
      where CInvoicePosting.CInvoice_ID = CInvoice.CInvoice_ID
      ,first Posting no-lock                                                    
      where Posting.Posting_ID  = CInvoicePosting.Posting_ID                              
      , each postingline                                                    
      where PostingLine.Posting_ID = Posting.Posting_ID                            
      no-lock:
         
         
         
         find first GL 
         where GL.GL_ID  = Postingline.GL_ID
         no-lock no-error.

         if (GL.GLTypeCode = "SYSTEM" and GL.GLSystemTypeCode = "CIREC") then do:

            next.

         end.


            arr_line[1] = F_Date_Format(CInvoice.CInvoiceDate).
            if Cinvoice.CinvoiceType = "INVOICE" 
            then arr_line[2] = "FF".
            else arr_line[2] = "AF".
            /*
            arr_line[3] = GL.GLCode.
            
            if (string(GL.GLCode)  begins "408" OR string(GL.GLCode)  begins "9") then do:
               define buffer zzGL for GL.
               // find first Division
               // where Division.Division_ID = Postingline.Division_ID
               // no-lock no-error.
               // if available Division then 
               // arr_line[3] = string(Division.DivisionCode).


                  for first APMatchingLN where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID:
                     
                     find first zzGL
                     where zzGL.GL_ID = APMatchingLN.GL_ID
                     no-lock no-error.
                     if available zzGL then 
                     arr_line[3] = string(zzGL.GLCode).
                  end.

            end.
            */   

              /*arr_line[3] = GL.GLCode.*/
            
            /*if (string(GL.GLCode)  begins "408" OR string(GL.GLCode)  begins "9") then do:
               define buffer zzGL for GL.
               // find first Division
               // where Division.Division_ID = Postingline.Division_ID
               // no-lock no-error.
               // if available Division then 
               // arr_line[3] = string(Division.DivisionCode).


               for first APMatchingLN where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID:
                  
                  find first zzGL
                  where zzGL.GL_ID = APMatchingLN.GL_ID
                  no-lock no-error.
                  if available zzGL then 
                  arr_line[3] = string(zzGL.GLCode).
               end.

            end.*/
            
            if substring(trim(string(GL.GLcode)),1,3)  <> "408"
            then arr_line[3] = string(GL.GLCode).
            else if (string(GL.GLcode) = "4081000"
            OR  string(GL.GLcode) = "4081100" 
            OR  string(Gl.GLcode) = "4081101"
            ) Then do :
               define buffer zzGL for GL.

               if string(GL.GLcode) = "4081000"
               or string(GL.GLcode) = "4081100"
               then do:

                  find first Division
                  where Division.Division_ID = Postingline.Division_ID
                  no-lock no-error.
                  if available Division then do :
                     arr_line[3] = string(Division.DivisionCode).
                     string(Division.DivisionCode).
                  end.

               end. /*if string(GL.GLcode) = "4081000"...*/
               else do :

                  for first APMatchingLN 
                  where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID
                  no-lock :
                     find first zzGL
                     where zzGL.GL_ID = APMatchingLN.GL_ID
                     no-lock no-error.
                     if available zzGL then 
                     arr_line[3] = string(zzGL.GLCode).
                  end.


               end. /*else do..*/
                  
            end. /*if (string(GL.GLcode)..*/


            //R001

            arr_line[5] = "".
            //arr_line[5] = string("F" + Creditor.CreditorCode).
            
            arr_line[6] = "".


            arr_line[7] = "".
            arr_line[8] = "".

            define variable nbr_zero as integer.
            nbr_zero = 9 - LENGTH(string(CInvoice.CInvoiceVoucher)).
            define variable i as integer.
            define variable voucher as character.
            voucher = string(CInvoice.CInvoiceVoucher).
            DO i = 1 TO nbr_zero:
            voucher = "0" + voucher.
            END.

            arr_line[9] = string(CInvoice.CInvoicePostingYear) + "/" + string(Journal.JournalCode) + "/" + voucher.
            arr_line[10] = v_subaccount.
            arr_line[11] = CInvoice.CInvoiceDescription.
            arr_line[12] = "".
            
            arr_line[13] = "".
            //arr_line[13] = F_Date_Format(CInvoice.CInvoiceDueDate).

            arr_line[14] = "D" .

            arr_line[15] = string(PostingLine.PostingLineDebitLC - PostingLine.PostingLineCreditLC).

            if decimal(arr_line[15]) < 0 then do:
            arr_line[15] = string(- decimal(arr_line[15])).
            arr_line[14] = "C" .
            end.

            
            arr_line[16] = CInvoice.CInvoiceReference.

            arr_line[17] = "".

            
            
            arr_line[18] = v_currency_code.


            arr_line[19] = string(PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC).

            if (decimal(arr_line[19]) < 0) then
            arr_line[19] = string(-1 * decimal(arr_line[19])).

            
            arr_line[20] = F_Date_Format(CInvoice.CInvoicePostingDate).

            arr_line[21] = "".
            arr_line[22] = string(num_line).
            arr_line[23] = "0" .


            
            
            for each CInvoiceVat                                                
            where CInvoicevat.CInvoice_ID = CInvoice.CInvoice_ID                            
            no-lock:
               if (GL.GLTypeCode = "VAT"  and (GL.GL_ID = CInvoiceVat.NormalTaxGL_ID or GL.GL_ID = CInvoiceVat.AbsRetTaxGL_ID)) then do:

                  find first vat
                  where CInvoiceVat.Vat_ID = Vat.Vat_ID
                  no-lock no-error.
                  if available vat then arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
     
                 
                  arr_line[4] = "V".
                  arr_line[21] = "".
                  arr_line[23] = string(CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC).
                     
               end.

               else if (GL.GLTypeCode = "STANDARD" or GL.GLTypeCode = "SYSTEM") then do:
                  
                  if ((CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) -
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) <= 0.01 
                  and (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) -
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) >= (- 0.01 )) or 
                  (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) -
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) = 0

                  or (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) =
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) 
                  or (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) =
                  - (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC)

                  or (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) =
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) + 0.01
                  or (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) =
                  - (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) - 0.01

                  or (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) + 0.01 =
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC)
                  or (CInvoiceVat.CInvoiceVatVatDebitTC - CInvoiceVat.CInvoiceVatVatCreditTC) - 0.01 =
                  - (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) 

                  or ((CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) -
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) <= 0.01 
                  and (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) -
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) >= (- 0.01 )) or 
                  (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) -
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) = 0

                  or (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) =
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) 
                  or (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) =
                  - (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC)

                  or (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) =
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) + 0.01
                  or (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) =
                  - (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) - 0.01

                  or (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) + 0.01 =
                  (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC)
                  or (CInvoiceVat.CInvoiceVatVatBaseDebitTC - CInvoiceVat.CInvoiceVatVatBaseCreditTC) - 0.01 =
                  - (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC) 

                  then do:
                     
                     find first vat 
                     where CInvoiceVat.Vat_ID = Vat.Vat_ID
                     no-lock no-error.
                     if available vat then arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).

                  end.
                 

               end.
            end.
            /*if arr_line[17] = "" and GL.GLTypeCode <> "VAT"  then do :
               for each APMatching no-lock
               where APMatching.CInvoice_ID = CInvoice.CInvoice_ID
               , first APMatchingLn no-lock
               where APMatchingLn.APMatching_ID = APMatching.APMatching_ID
               , first APMatchingLnTax
               where APMatchingLnTax.APMatchingLn_ID = APMatchingLn.APMatchingLn_ID
               no-lock:
                  define var ii  as int .

                  find first Vat of APMatchingLNTax
                  no-lock no-error.
                  if available Vat 
                  then do: 

                     if APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID then do:
                        arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
                        //message ii = ii + 1  "/" Glcode  "/" string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
                     end.
                  end.

               end.
            end. */
            /*if arr_line[17] = "" and GL.GLTypeCode <> "VAT" then do:

               for first APMatchingLN where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID:
                  
                  for first APMatchingLNTax of APMatchingLN:
                     for first Vat of APMatchingLNTax:
                        arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
                     end.

                  end.

               end.

            end.

            for each postingvat 
            where PostingVat.PostingLine_ID = PostingLine.PostingLine_ID
            no-lock : 
               if (GL.GLTypeCode <> "VAT") then do:

                  /*arr_line[4] = "V".
                  arr_line[17] = "".*/
                    
                     for each vat 
                     where PostingVat.Vat_ID = Vat.Vat_ID
                     no-lock :
                        arr_line[17] = string("D" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
                        /*Cinvoice.CustomCombo0 = "exp" .
                        run add_row(input arr_line). */
                        
                     end. /* for each vat */
               end. /*if (GL.GLTypeCode = "VAT") */
            end. /*for each postingvat */
            */
               


            if (GL.GLTypeCode = "SYSTEM" ) then do:

               arr_line[4] = "G".
               /*find first PostingVat  
               where PostingVat.PostingLine_ID = PostingLine.PostingLine_ID
               no-lock no-error.
               if available PostingVat then find first vat                                                              
               where vat.vat_ID = PostingVat.vat_ID                            
               no-lock no-error.                                                          
               if available vat then arr_line[17] = "D" + vat.VatCode + " " + "-" + " " + vat.VatDescription.*/

             

               run add_row(input arr_line).
               Cinvoice.CustomCombo0 = "exp" .  

               arr_line[4] = "A".

               find first project                                                       
               where  Project.Project_ID = PostingLine.Project_ID
               no-lock no-error.

               find first CostCentre                                                    
               where CostCentre.CostCentre_ID = Postingline.CostCentre_ID               
               no-lock no-error.

               for first APMatchingLN 
                  where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID
                  no-lock :
                     
                     if APMatchingLN.APMatchingLNPVodItemType = "MEMOITEM" then do:

                        find first CostCentre                                                    
                        where CostCentre.CostCentre_ID = APMatchingLN.CostCentre_ID               
                        no-lock no-error.

                        find first project                                                       
                        where  Project.Project_ID = APMatchingLN.Project_ID
                        no-lock no-error.

                     end.
               end.
               
               if (available CostCentre) then
                     arr_line[6] = CostCentre.CostCentreCode. else arr_line[6] = "".

               arr_line[21] = "AXE1".
               
               run add_row(input arr_line).

               if (available Project) then
                     arr_line[6] = Project.ProjectCode. else arr_line[6] = "".

               arr_line[21] = "AXE2".
               run add_row(input arr_line).
   
               end.

            if (GL.GLTypeCode = "STANDARD") then do:

               arr_line[4] = "G".
               /*find first PostingVat  
               where PostingVat.PostingLine_ID = PostingLine.PostingLine_ID
               no-lock no-error.
               if available PostingVat then find first vat                                                              
               where vat.vat_ID = PostingVat.vat_ID                            
               no-lock no-error.                                                          
               if available vat then arr_line[17] = "D" + vat.VatCode + " " + "-" + " " + vat.VatDescription.*/
               

               run add_row(input arr_line).
               Cinvoice.CustomCombo0 = "exp". 
               Cinvoice.CustomDate0  = today.

               arr_line[4] = "A".

               find first project                                                       
               where  Project.Project_ID = PostingLine.Project_ID
               no-lock no-error.

               find first CostCentre                                                    
               where CostCentre.CostCentre_ID = Postingline.CostCentre_ID               
               no-lock no-error. 

               for first APMatchingLN 
                  where APMatchingLN.PvoPostingLine_ID = PostingLine.PostingLine_ID
                  no-lock :
                     
                     if APMatchingLN.APMatchingLNPVodItemType = "MEMOITEM" then do:

                        find first CostCentre                                                    
                        where CostCentre.CostCentre_ID = APMatchingLN.CostCentre_ID               
                        no-lock no-error.

                        find first project                                                       
                        where  Project.Project_ID = APMatchingLN.Project_ID
                        no-lock no-error.

                     end.
               end. 
                  
               if (available CostCentre) then
               arr_line[6] = CostCentre.CostCentreCode. else arr_line[6] = "".

               arr_line[21] = "AXE1".
               run add_row(input arr_line).

               if (available Project) then
                  arr_line[6] = Project.ProjectCode. else arr_line[6] = "".

               arr_line[21] = "AXE2".
               run add_row(input arr_line).

            end.

            if (GL.GLTypeCode = "VAT" ) then do:
               
                     Cinvoice.CustomCombo0 = "exp" .
                     Cinvoice.CustomDate0  = today.
                     run add_row(input arr_line).
                  
               /*Cinvoice.CustomCombo0 = "exp" .
                        run add_row(input arr_line). */
            END.

            

         if GL.GLTypeCode = "CREDITORCONTROL" then do:
            arr_line[5]   =  v_subaccount.
            /*arr_line[5] = string("F" + Creditor.CreditorCode).*/
            arr_line[4] = "X".
            arr_line[12] = "VI".
            arr_line[17] = "".
            arr_line[13] = F_Date_Format(CInvoice.CInvoiceDueDate).


            run add_row(input arr_line).
            Cinvoice.CustomCombo0 = "exp" .
            Cinvoice.CustomDate0  = today.
         end.



      end.    
   release Cinvoice. 

   run write_csv.
                                                  
   end. 
   
   

   
end procedure.
