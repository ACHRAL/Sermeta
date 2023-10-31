/******************************************************************************/
/* Program name  : zzintsageclt.p                                             */
/* Title         : Interface factures clients                                 */
/*                                                                            */
/* Purpose       : Interface factures clients pour exporter vers sage         */
/*                                                                            */
/* Author        : Achref Laayouni                                            */
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

define  variable v_ref_fr        as     character format "x(30)"        no-undo.
define  variable v_ref_to        as     character format "x(30)"        no-undo.
define  variable v_ad_fac_fr     like   Debtor.DebtorCode               no-undo.
define  variable v_ad_fac_to     like   Debtor.DebtorCode               no-undo.
define  variable v_invo_date_fr  like   DInvoice.DInvoiceDate           no-undo.
define  variable v_invo_date_to  like   DInvoice.DInvoiceDate           no-undo.
define  variable v_entity_fr     like   Company.CompanyCode             no-undo.
define  variable v_entity_to     like   Company.CompanyCode             no-undo.
define  variable v_op_path       as     character                       no-undo.
define  variable v_rexport       as     logical   initial  yes           no-undo.
define  variable v_file          as     character format "x(60)"        no-undo.
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
   field field_21 as integer
.
define temp-table tt_test 
   field tt_field_1 as character 
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
   v_ref_fr           colon 10 label "Refrence"
   v_ref_to           colon 47 label "A"
   v_ad_fac_fr        colon 10 label "adr fact"
   v_ad_fac_to        colon 47 label "A"
   v_invo_date_fr     colon 10 label "Date"
   v_invo_date_to     colon 47 label "A"
   v_entity_fr        colon 10 label "Entite"
   v_entity_to        colon 47 label "A"
   skip(1)
   v_rexport           colon 20 label "Re-Export"
   skip(1)
   v_file             colon 17 label "LIEN de L'EXPORT"
   with Frame main_frame side-labels width 80. 
   /* SET EXTERNAL LABELS */
setFrameLabels(frame main_frame:handle).

/******************************************************************************
 _____        _ _  _       _ _
|_   _|     (_) | (_)     | (_)
  | |  _ __  _| |_ _  __ _| |_ _______
  | | | '_ \| | __| |/ _` | | |_  / _ \
 _| |_| | | | | |_| | (_| | | |/ /  __/
|_____|_| |_|_|\__|_|\__,_|_|_/___\___|                              INITIALIZE
*******************************************************************************/

assign 
   v_invo_date_fr = current_date
   v_invo_date_to = current_date
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
   and   code_fldname  = ip_fldname
   and   code_value    = "Yes"
   no-lock no-error.
      
   if available code_mstr then do : 
      v_path = code_cmmt + "/"  .
      return v_path.
   end. 
   else return v_path .

END FUNCTION.  /* F_get_gn_parm */   


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

   if v_ref_to       = hi_char  then v_ref_to        = "" .
   if v_ad_fac_to    = hi_char  then v_ad_fac_to     = "" .
   if v_entity_to    = hi_char  then v_entity_to     = "" .
   if v_invo_date_fr = low_date then v_invo_date_fr  = ?  .
   if v_invo_date_to = hi_date  then v_invo_date_to  = ?  .


   display v_file with frame main_frame.
   update
      v_ref_fr       
      v_ref_to           
      v_ad_fac_fr    
      v_ad_fac_to    
      v_invo_date_fr 
      v_invo_date_to 
      v_entity_fr    
      v_entity_to    
      v_rexport       
   with frame main_frame.


   if v_ref_to        = "" then v_ref_to         = hi_char.
   if v_ad_fac_to     = "" then v_ad_fac_to      = hi_char.
   if v_entity_to     = "" then v_entity_to      = hi_char.
   if v_invo_date_fr  = ?  then v_invo_date_fr   = low_date.
   if v_invo_date_to  = ?  then v_invo_date_to   = hi_date.

   assign
      v_op_path = ""
      v_file = "sales_Interface_Sage_"
               + string(day(today),"99")                
               + string(month(today),"99")              
               + string(year(today),"9999")             
               + substring(string(time,"HH:MM:SS"),1,2) 
               + substring(string(time,"HH:MM:SS"),4,2) 
               + substring(string(time,"HH:MM:SS"),7,2) 
               + ".txt"
   .

   v_op_path = F_get_gn_parm("Sage_Sales_Inter" , "Yes").

   if v_op_path <> "" then do :
      if v_rexport = yes then 
      run search_data(input "exp",
                     input v_ref_fr,      
                     input v_ref_to,      
                     input v_invo_date_fr,
                     input v_invo_date_to,
                     input v_ad_fac_fr,   
                     input v_ad_fac_to,   
                     input v_entity_fr,   
                     input v_entity_to).

      else run search_data(input "",
                           input v_ref_fr,      
                           input v_ref_to,      
                           input v_invo_date_fr,
                           input v_invo_date_to,
                           input v_ad_fac_fr,   
                           input v_ad_fac_to,   
                           input v_entity_fr,   
                           input v_entity_to).
            
      v_file =  v_op_path + v_file  .

      run P_generate_file (input ";" ).
   end. /*if v_op_path <> "" then do */
   else do : 

      {us/bbi/pxmsg.i &MSGNUM=99158 &ERRORLEVEL=4}.
      next-prompt v_rexport with frame main_frame.
      undo mainloop, retry mainloop.

   end.  /*else do */

end. /*mainloop*/

/*******************************************************************************
_____                        _
|  __ \                      | |
| |__) | __ ___   ___ ___  __| |_   _ _ __ ___  ___
|  ___/ '__/ _ \ / __/ _ \/ _` | | | | '__/ _ \/ __|
| |   | | | (_) | (_|  __/ (_| | |_| | | |  __/\__ \
|_|   |_|  \___/ \___\___|\__,_|\__,_|_|  \___||___/                 PROCEDURES
*******************************************************************************/ 
PROCEDURE add_row :
         
   define input parameter i_arr_line as character extent 21.

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
   tt_output.field_21  = decimal(i_arr_line[21]).

END PROCEDURE. /*PROCEDURE add_row*/

PROCEDURE search_data :

   define input parameter i_exp           as   character                no-undo.
   define input parameter ip_ref_fr       as   character format "x(30)" no-undo.
   define input parameter ip_ref_to       as   character format "x(30)" no-undo.
   define input parameter ip_invo_date_fr like DInvoice.DInvoiceDate    no-undo.
   define input parameter ip_invo_date_to like DInvoice.DInvoiceDate    no-undo.
   define input parameter ip_ad_fac_fr    like Debtor.DebtorCode        no-undo.
   define input parameter ip_ad_fac_to    like Debtor.DebtorCode        no-undo.
   define input parameter ip_entity_fr    like Company.CompanyCode      no-undo.
   define input parameter ip_entity_to    like Company.CompanyCode      no-undo.
   
   
   
   define  variable v_BR_name  like BusinessRelation.BusinessRelationname1 no-undo.
   define variable v_subaccount    as character    no-undo.
   define variable v_currency_code as character    no-undo.
   define variable file_name       as character    no-undo.
   define variable arr as character extent.

   define variable arr_line as character extent 21.
   define variable nbr_zero as integer   no-undo.
   define variable i        as integer   no-undo.
   define variable voucher  as character no-undo.
   define variable voucher_f as integer   no-undo.
   define variable voucher_t as integer   no-undo.
   define variable date_f as integer      no-undo.
   define variable date_t as integer      no-undo.
   define variable journal_f as character no-undo.
   define variable journal_t as character no-undo.

   define buffer zz_dinvoice     for DInvoice.
   define buffer  b_PostingLine  for postingline.
   define buffer  b_GL           for GL.
   if NUM-ENTRIES( v_ref_fr,"/") > 2 then do:
   assign
      voucher_f = integer(ENTRY(3,v_ref_fr,"/"))
      voucher_t = integer(ENTRY(3,v_ref_to,"/"))

      date_f = integer(ENTRY(1,v_ref_fr,"/"))
      date_t = integer(ENTRY(1,v_ref_to,"/"))

      journal_f = string(ENTRY(2,v_ref_fr,"/"))
      journal_t = string(ENTRY(2,v_ref_to,"/"))
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

         v_BR_name = ""
      .
   end.

   for each DInvoice exclusive-lock
   where  DInvoice.DInvoiceVoucher     >=  voucher_f 
   and    DInvoice.DInvoiceVoucher     <=    voucher_t
   and    DInvoice.DInvoicePostingYear >=  date_f
   and    DInvoice.DInvoicePostingYear <=  date_t
   and    DInvoice.DInvoiceDate        >= ip_invo_date_fr
   and    DInvoice.DInvoiceDate        <= ip_invo_date_to
   and    (Dinvoice.DInvoiceType       = "CREDITNOTE"
           OR Dinvoice.DInvoiceType    = "INVOICE")
   and    DInvoice.CustomCombo0        = i_exp
   ,first Debtor   no-lock
   where  Debtor.Debtor_ID   = DInvoice.Debtor_ID
   and    Debtor.DebtorCode >= ip_ad_fac_fr
   and    Debtor.DebtorCode <= ip_ad_fac_to
   ,first Company  no-lock
   where  Company.Company_ID   = DInvoice.Company_ID
   and    Company.CompanyCode >= ip_entity_fr
   and    Company.CompanyCode <= ip_entity_to
   ,first Reason
   where  Reason.Reason_ID    = Dinvoice.Reason_ID
   and    Reason.ReasonCode   <> "AP-PO-INITIAL"
   ,first  Journal                               
   where  Journal.Journal_ID =  DInvoice.Journal_ID
   and Journal.JournalCode   >= journal_f
   and Journal.JournalCode   <= journal_t
   no-lock:

      /*Rule 02 ne pas inclure les factures extroné*/

      if   Dinvoice.DinvoiceType = "INVOICE" then do:
         
         find first zz_dinvoice where zz_dinvoice.DinvoiceType = "CREDITNOTE" and zz_dinvoice.DinvoiceDIText = dinvoice.DinvoiceDIText
         and zz_dinvoice.CustomCombo0 = Dinvoice.CustomCombo0 no-lock no-error.
         
         if available zz_dinvoice then do:
            next.
         end. /*if available zz_dinvoice then do*/
         
      end. /*if   Dinvoice.DinvoiceType = "INVOICE" */

      if  Dinvoice.DinvoiceType = "CREDITNOTE" then do:

         find first zz_dinvoice where zz_dinvoice.DinvoiceType = "INVOICE" and zz_dinvoice.DinvoiceDIText = Dinvoice.DinvoiceDIText 
         and zz_dinvoice.CustomCombo0 = Dinvoice.CustomCombo0 no-lock no-error.

         if available zz_dinvoice then do:
            next.
         end. /*if available zz_dinvoice then do*/

      end. /*if  Dinvoice.DinvoiceType = "CREDITNOTE"*/

                                                                                      
      find first BusinessRelation                                              
      where BusinessRelation.BusinessRelation_ID = Debtor.BusinessRelation_ID  
      no-lock no-error.
      if available BusinessRelation then v_BR_name =  BusinessRelation.BusinessRelationname1.  
      

      find first Division
      where Division.Division_ID = DInvoice.Division_ID 
      no-lock no-error.
      if available Division then v_subaccount = Division.DivisionCode. 

      find first Currency                                                      
      where  Currency.Currency_ID  = DInvoice.DInvoiceCurrency_ID 
      no-lock no-error. 
      if available Currency then v_currency_code = Currency.CurrencyCode.
      define variable a as integer initial 0  no-undo.
      define variable b as character  initial "" no-undo.
         
      for each DInvoiceVat                                                
      where Dinvoicevat.Dinvoice_iD = Dinvoice.Dinvoice_ID                            
      no-lock:
       
         a = a + 1 .
         if a = 2 then do : 
            b = "" .
            leave. 
         end.
         find first vat 
         where DInvoiceVat.Vat_ID = Vat.Vat_ID
         no-lock no-error.
         if available vat then  b = string("C" + vat.VatCode + " " + "-" + " " + vat.VatDescription).

      end.
      for each DInvoicePosting no-lock
      where DInvoicePosting.DInvoice_ID = DInvoice.DInvoice_ID
      ,first Posting no-lock                                                    
      where Posting.Posting_ID  = DInvoicePosting.Posting_ID                              
      , each postingline                                                    
      where PostingLine.Posting_ID = Posting.Posting_ID                            
      no-lock:

         find first GL 
         where GL.GL_ID  = Postingline.GL_ID
         no-lock no-error.

         arr_line[1] = F_Date_Format(DInvoice.DInvoiceDate).
         if Dinvoice.DinvoiceType = "INVOICE" 
         then arr_line[2] = "FC".
         else arr_line[2] = "AC".

         arr_line[3] = GL.GLCode.
         arr_line[5] = "".
         arr_line[6] = "".
         arr_line[7] = "".
         
         arr_line[8] = "".
         
         nbr_zero = 9 - LENGTH(string(DInvoice.DInvoiceVoucher)).

         voucher = string(DInvoice.DInvoiceVoucher).
         DO i = 1 TO nbr_zero:
            voucher = "0" + voucher.
         END.

         arr_line[9]  = string(DInvoice.DInvoicePostingYear) + "/" + string(Journal.JournalCode) + "/" + voucher.
         arr_line[16] = string(DInvoice.DInvoicePostingYear) + "/" + string(Journal.JournalCode) + "/" + voucher.
            
         arr_line[10] = "C" + Debtor.DebtorCode.
         arr_line[11] = v_BR_name.

         arr_line[12] = "".
         arr_line[13] = "".
         arr_line[14] = "D" .
         arr_line[15] = string(PostingLine.PostingLineDebitLC - PostingLine.PostingLineCreditLC).
         
         if decimal(arr_line[15]) < 0 then do:

            arr_line[15] = string(- decimal(arr_line[15])).
            arr_line[14] = "C" .

         end. /*if decimal(arr_line[15]) < 0 then do*/

         
         arr_line[17] = b .
         arr_line[18] = v_currency_code.

         arr_line[19] = string(PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC).
         
         if (decimal(arr_line[19]) < 0) then
         arr_line[19] = string(-1 * decimal(arr_line[19])).


         for each DInvoiceVat                                                
         where Dinvoicevat.Dinvoice_iD = Dinvoice.Dinvoice_ID                            
         no-lock:
            if (GL.GLTypeCode = "VAT" and GL.GL_ID = DInvoiceVat.NormalTaxGL_ID) then do:
               
                  find first vat 
                  where DInvoiceVat.Vat_ID = Vat.Vat_ID
                  no-lock no-error.
                  if available vat then  arr_line[17] = string("C" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
                  arr_line[4] = "G".
                  arr_line[21] = "2".
            end.
            else if (GL.GLTypeCode = "STANDARD") then do:

               if (DInvoiceVat.DInvoiceVatVatBaseDebitTC - DInvoiceVat.DInvoiceVatVatBaseCreditTC) = (PostingLine.PostingLineDebitTC - PostingLine.PostingLineCreditTC)
               then do:
                  find first vat 
                  where DInvoiceVat.Vat_ID = Vat.Vat_ID
                  no-lock no-error.
                  if available vat then  arr_line[17] = string("C" + vat.VatCode + " " + "-" + " " + vat.VatDescription).
                  
               end.
            end.
         end.
         
         if (GL.GLTypeCode = "STANDARD") then do:

            arr_line[4] = "G".


            run add_row(input arr_line).
            Dinvoice.CustomCombo0 = "exp" .
            arr_line[4] = "A".

            if arr_line[3] begins ("6") 
            or  arr_line[3] begins ("7") 
            then arr_line[21] = "1" .
            else arr_line[21] = "3" .

         end. /*if (GL.GLTypeCode = "STANDARD")*/
         
         for each project                                                      
         where  Project.Project_ID = PostingLine.Project_ID
         no-lock :
            arr_line[6] = Project.ProjectCode.
            arr_line[7] = "".
            run add_row(input arr_line).
         end. /*for each project*/
   

         for each CostCentre                                                    
         where CostCentre.CostCentre_ID = Postingline.CostCentre_ID              
         no-lock :         

            arr_line[6] = "".
            arr_line[7] = CostCentre.CostCentreCode.
            run add_row(input arr_line).

         end. /*for each CostCentre */
         

         if (GL.GLTypeCode = "VAT") then do:
            
            arr_line[17] = "".
            arr_line[4] = "G".

            if decimal(arr_line[19]) <> 0 
            then do :

               run add_row(input arr_line). 
               Dinvoice.CustomCombo0 = "exp" .

            end. /*iif decimal(arr_line[19]) <> 0 .. */

         end. /*if (GL.GLTypeCode = "VAT") then do:*/

         if GL.GLTypeCode = "DEBTORCONTROL" then do:

            /*arr_line[5] = string("C" + Debtor.DebtorCode).*/
            arr_line[5] =  v_subaccount .
            arr_line[4] = "X".
            arr_line[12] = "VI".
            arr_line[17] = "".
            arr_line[13] = F_Date_Format(DInvoice.DInvoiceDueDate).

            if arr_line[3] begins ("6") 
            or arr_line[3] begins ("7") then arr_line[21] = "1" .
            else arr_line[21] = "3" .
            
            run add_row(input arr_line).
            Dinvoice.CustomCombo0 = "exp" .

         end. /*if GL.GLTypeCode = "DEBTORCONTROL" then do:*/

      end. /* for each DInvoicePosting*/

   end. /*for each DInvoice */

END PROCEDURE. /*PROCEDURE search_data*/


PROCEDURE P_generate_file:

   define input parameter  ip_file_sp as character no-undo.
   output stream file_csv to value (v_file).
   
   for each tt_output 
   where field_21 = 1 :

      put stream file_csv unformatted 
         field_1    ip_file_sp
         field_2    ip_file_sp
         field_3    ip_file_sp
         field_4    ip_file_sp
         field_5    ip_file_sp
         field_6    ip_file_sp
         field_7    ip_file_sp
         field_8    ip_file_sp
         field_9    ip_file_sp
         field_10   ip_file_sp
         field_11   ip_file_sp
         field_12   ip_file_sp
         field_13   ip_file_sp
         field_14   ip_file_sp
         field_15   ip_file_sp
         field_16   ip_file_sp
         field_17   ip_file_sp
         field_18   ip_file_sp
         field_19   ip_file_sp
         field_20     
      skip.
         
   end. /*for each tt_output */

   for each tt_output 
   where field_21 = 2 :

      put stream file_csv unformatted 
         field_1    ip_file_sp
         field_2    ip_file_sp
         field_3    ip_file_sp
         field_4    ip_file_sp
         field_5    ip_file_sp
         field_6    ip_file_sp
         field_7    ip_file_sp
         field_8    ip_file_sp
         field_9    ip_file_sp
         field_10   ip_file_sp
         field_11   ip_file_sp
         field_12   ip_file_sp
         field_13   ip_file_sp
         field_14   ip_file_sp
         field_15   ip_file_sp
         field_16   ip_file_sp
         field_17   ip_file_sp
         field_18   ip_file_sp
         field_19   ip_file_sp
         field_20     
      skip.
         
   end. /*for each tt_output */

   for each tt_output 
   where field_21 = 3 :

      put stream file_csv unformatted 
         field_1    ip_file_sp
         field_2    ip_file_sp
         field_3    ip_file_sp
         field_4    ip_file_sp
         field_5    ip_file_sp
         field_6    ip_file_sp
         field_7    ip_file_sp
         field_8    ip_file_sp
         field_9    ip_file_sp
         field_10   ip_file_sp
         field_11   ip_file_sp
         field_12   ip_file_sp
         field_13   ip_file_sp
         field_14   ip_file_sp
         field_15   ip_file_sp
         field_16   ip_file_sp
         field_17   ip_file_sp
         field_18   ip_file_sp
         field_19   ip_file_sp
         field_20     
      skip.
         
   end. /*for each tt_output */
         
   output stream file_csv close.

END PROCEDURE. /*P_generate_file*/