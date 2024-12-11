SELECT
  T005.MANDT AS Client_MANDT,
  T005.LAND1 AS CountryKey_LAND1,
  T005T.LANDX AS CountryName_LANDX,
  T005T.SPRAS AS Language_SPRAS,
  T005T.NATIO AS Nationality_NATIO,
  T005T.LANDX50 AS CountryName__max50Characters___LANDX50,
  T005T.NATIO50 AS Nationality__max50Characters___NATIO50,
  T005T.PRQ_SPREGT AS SuperRegionPerCountryText_PRQ_SPREGT,
  T005.LANDK AS VehicleCountryKey_LANDK,
  T005.LNPLZ AS PostalCodeLength_LNPLZ,
  T005.PRPLZ AS RuleForThePostalCodeFieldCheck_PRPLZ,
  T005.ADDRS AS FormattingRoutineKeyForPrintingAddresses_ADDRS,
  T005.XPLZS AS Flag_StreetAddressPostalCodeRequiredEntry_XPLZS,
  T005.XPLPF AS Flag_PoBoxPostalCodeRequired_XPLPF,
  T005.SPRAS AS CountryLanguage_SPRAS,
  T005.XLAND AS CountryVersionFlag_XLAND,
  T005.XADDR AS Flag_PrintCountryNameInForeignAddresses_XADDR,
  T005.NMFMT AS StandardNameFormat_NMFMT,
  T005.XREGS AS Flag_CityFileAddressCheck_XREGS,
  T005.XPLST AS FlagStreetSpecificPostalCode__cityFile___XPLST,
  T005.INTCA AS CountryIsoCode_INTCA,
  T005.INTCA3 AS IsoCountryCode3Char_INTCA3,
  T005.INTCN3 AS IsoCountryCodeNumeric3Characters_INTCN3,
  T005.XEGLD AS Indicator_EuropeanUnionMember_XEGLD,
  T005.XSKFN AS Indicator_DiscountBaseAmountIsTheNetValue_XSKFN,
  T005.XMWSN AS Indicator_BaseAmountForTaxIsNetOfDiscount_XMWSN,
  T005.LNBKN AS BankAccountNumberLength_LNBKN,
  T005.PRBKN AS RuleForCheckingBankAccountNumberField_PRBKN,
  T005.LNBLZ AS BankNumberLength_LNBLZ,
  T005.PRBLZ AS RuleForCheckingBankNumberField_PRBLZ,
  T005.LNPSK AS PostOfficeBankCurrentAccountNumberLength_LNPSK,
  T005.PRPSK AS RuleForCheckingPostalCheckAccountNumberField_PRPSK,
  T005.XPRBK AS Indicator_UseCheckModuleForBankFields_XPRBK,
  T005.BNKEY AS NameOfTheBankKey_BNKEY,
  T005.LNBKS AS LengthOfBankKey_LNBKS,
  T005.PRBKS AS RuleForCheckingBankKeyField_PRBKS,
  T005.XPRSO AS Indicator_UseCheckModuleForTaxFieldsEtc_XPRSO,
  T005.PRUIN AS RuleForCheckingVatRegistrationNumberField_PRUIN,
  T005.UINLN AS VatRegistrationNumberLength_UINLN,
  T005.LNST1 AS PermittedInputLengthForTaxNumbre1_LNST1,
  T005.PRST1 AS RuleForCheckingTaxCode1Field_PRST1,
  T005.LNST2 AS PermittedInputLengthForTaxNumber2_LNST2,
  T005.PRST2 AS RuleForCheckingTaxCode2Field_PRST2,
  T005.LNST3 AS PermittedInputLengthForTaxNumber3_LNST3,
  T005.PRST3 AS RuleForCheckingTaxCode3Field_PRST3,
  T005.LNST4 AS PermittedInputLengthForTaxNumber4_LNST4,
  T005.PRST4 AS RuleForCheckingTaxCode4Field_PRST4,
  T005.LNST5 AS PermittedInputLengthForTaxNumber5_LNST5,
  T005.PRST5 AS RuleForCheckingTaxCode5Field_PRST5,
  T005.LANDD AS Duevo_Nationality_LANDD,
  T005.KALSM AS Procedure__pricing_KALSM,
  T005.LANDA AS AlternativeCountryKey_LANDA,
  T005.WECHF AS PaymentPeriodForBillOfExchange_WECHF,
  T005.LKVRZ AS ShortNameForForeignTradeStatistics_LKVRZ,
  T005.INTCN AS IntrastatCode_INTCN,
  T005.XDEZP AS DecimalPointFormat_XDEZP,
  T005.DATFM AS DateFormat_DATFM,
  T005.CURIN AS CurrencyKeyOfTheIndexBasedCurrency_CURIN,
  T005.CURHA AS CurrencyKeyOfTheHardCurrency_CURHA,
  T005.WAERS AS CountryCurrency_WAERS,
  T005.KURST AS ExchangeRateTypeForTranslationIntoCountryCurrency_KURST,
  T005.AFAPL AS ChartOfDepreciatonForAssetValuation_AFAPL,
  T005.GWGWRT AS MaximumLowValueAssetAmount_GWGWRT,
  T005.UMRWRT AS NetBookValueForChangeoverOfDepreciationMethod_UMRWRT,
  T005.KZRBWB AS IndicatorPostNetBookValueForRetirement_KZRBWB,
  T005.XANZUM AS IndicatorTransferDownPaymentsFromPreviousYears_XANZUM,
  T005.CTNCONCEPT AS WithholdingTaxCertificateNumbering_Concepts_CTNCONCEPT,
  T005.KZSRV AS TaxesAtIndividualServiceLevel_KZSRV,
  T005.XXINVE AS Indicator_DisplayCapitalGoodsIndicator_XXINVE,
  T005.SUREG AS SuperRegionPerCountry_SUREG
FROM
  `{{ project_id_src }}.{{ dataset_cdc_processed_ecc }}.t005` AS T005
INNER JOIN
  `{{ project_id_src }}.{{ dataset_cdc_processed_ecc }}.t005t` AS T005T
  ON
    T005.MANDT = T005T.MANDT
    AND T005.LAND1 = T005T.LAND1
