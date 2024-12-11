SELECT
  marc.MANDT AS Client_MANDT,
  marc.MATNR AS MaterialNumber_MATNR,
  marc.WERKS AS Plant_WERKS,
  marc.PSTAT AS MaintainanceStatus_PSTAT,
  marc.LVORM AS FlagMaterialForDeletionAtPlantLevel_LVORM,
  marc.BWTTY AS ValuationCategory_BWTTY,
  marc.XCHAR AS BatchManagementIndicator_XCHAR,
  marc.MMSTA AS PlantSpecificMaterialStatus_MMSTA,
  marc.MMSTD AS DateFromWhichThePlantsSpecificMaterialStatusIsValid_MMSTD,
  marc.EISBE AS SafetyStock_EISBE
-- marc.MAABC AS ABCIndicator_MAABC,
-- marc.KZKRI AS IndicatorCriticalPart_KZKRI,
-- marc.EKGRP AS PurchasingGroup_EKGRP,
-- marc.AUSME AS UnitOfIssue_AUSME,
-- marc.DISPR AS MaterialMRPProfile_DISPR,
-- marc.DISMM AS MRPType_DISMM,
-- marc.DISPO AS MRPController_DISPO,
-- marc.KZDIE AS IndicatorMRPControllerIsBuyer_KZDIE,
-- marc.PLIFZ AS PlannedDeliveryTimeInDays_PLIFZ,
-- marc.WEBAZ AS GoodsReceiptProcessingTimeInDays_WEBAZ,
-- marc.PERKZ AS PeriodIndicator_PERKZ,
-- marc.AUSSS AS AssemblyScrapInPercent_AUSSS,
-- marc.DISLS AS LotSize _DISLS,
-- marc.BESKZ AS ProcurementType_BESKZ,
-- marc.SOBSL AS SpecialProcurementType_SOBSL,
-- marc.MINBE AS ReorderPoint_MINBE,
-- marc.BSTMI AS MinimumLotSize_BSTMI,
-- marc.BSTMA AS MaximumLotSize_BSTMA,
-- marc.BSTFE AS FixedLotSize_BSTFE
-- marc.BSTRF AS RoundingValueForPurchaseOrderQuantity_BSTRF,
-- marc.MABST AS MaximumStockLevel_MABST,
-- marc.LOSFX AS OrderingCosts_LOSFX,
-- marc.SDBKZ AS DependentRequirementsIndForIndividualAndCollReqmts_SDBKZ,
-- marc.LAGPR AS StorageCostsIndicator_LAGPR,
-- marc.ALTSL AS MethodForSelectingAlternativeBillsOfMateria_ALTSL,
-- marc.KZAUS AS DiscontinuationIndicator_KZAUS,
-- marc.AUSDT AS EffectiveOutDate_AUSDT,
-- marc.NFMAT AS FollowUpMaterial_NFMAT,
-- marc.KZBED AS IndicatorForRequirementsGrouping_KZBED,
-- marc.MISKZ AS MixedMRPIndicator_MISKZ,
-- marc.FHORI AS SchedulingMarginKeyForFloats_FHORI,
-- marc.PFREI AS IndicatorAutomaticFixingOfPlannedOrders_PFREI,
-- marc.FFREI AS ReleaseIndicatorForProductionOrders_FFREI,
-- marc.RGEKZ AS IndicatorBackflush_RGEKZ,
-- marc.FEVOR AS ProductionSupervisor_FEVOR,
-- marc.BEARZ AS Processing time_BEARZ,
-- marc.RUEZT AS SetupAndTeardownTime_RUEZT,
-- marc.TRANZ AS InteroperationTime_TRANZ,
-- marc.BASMG AS BaseQuantity_BASMG,
-- marc.DZEIT AS InHouseProductionTime_DZEIT,
-- marc.MAXLZ AS MaximumStoragePeriod_MAXLZ,
-- marc.LZEIH AS UnitForMaximumStoragePeriod_LZEIH,
-- marc.KZPRO AS IndicatorWithdrawalOfStockFromProductionBin_KZPRO,
-- marc.GPMKZ AS IndicatorMaterialIncludedInRoughCutPlanning_GPMKZ,
-- marc.UEETO AS OverdeliveryToleranceLimit_UEETO,
-- marc.UEETK AS IndicatorUnlimitedOverdeliveryAllowed_UEETK,
-- marc.UNETO AS UnderdeliveryToleranceLimit_UNETO,
-- marc.WZEIT AS TotalReplenishmentLeadTime_WZEIT,
-- marc.ATPKZ AS ReplacementPart_ATPKZ,
-- marc.VZUSL AS SurchargeFactorForCostInPercent_VZUSL,
-- marc.HERBL AS StateOfManufacture_HERBL,
-- marc.INSMK AS PostToInspectionStock_INSMK,
-- marc.SPROZ AS SampleForQualityInspection_SPROZ,
-- marc.QUAZT AS QuarantinePeriod_QUAZT,
-- marc.SSQSS AS ControlKeyForQualityManagementInProcurement_SSQSS,
-- marc.MPDAU AS MeanInspectionDuration_MPDAU,
-- marc.KZPPV AS IndicatorForInspectionPlan_KZPPV,
-- marc.KZDKZ AS DocumentationRequiredIndicator_KZDKZ,
-- marc.WSTGH AS ActiveSubstanceContent_WSTGH,
-- marc.PRFRQ AS IntervalUntilNextRecurringInspection_PRFRQ,
-- marc.NKMPR AS DateAccordingToCheckSamplingInspection_NKMPR,
-- marc.UMLMC AS StockInTransfer_UMLMC,
-- marc.LADGR AS LoadingGroup_LADGR,
-- marc.XCHPF AS BatchManagementRequirementIndicator_XCHPF,
-- marc.USEQU AS QuotaArrangementUsage_USEQU,
-- marc.LGRAD AS ServiceLevel_LGRAD,
-- marc.AUFTL AS SplittingIndicator_AUFTL,
-- marc.PLVAR AS PlanVersion_PLVAR,
-- marc.OTYPE AS ObjectType_OTYPE,
-- marc.OBJID AS ObjectID_OBJID,
-- marc.MTVFP AS CheckingGroupForAvailabilityCheck_MTVFP,
-- marc.PERIV AS FiscalYearVariant_PERIV,
-- marc.KZKFK AS IndicatorTakeCorrectionFactorsIntoAccount_KZKFK,
-- marc.VRVEZ AS ShippingSetupTime_VRVEZ,
-- marc.VBAMG AS BaseQuantityForCapacityPlanningInShipping_VBAMG,
-- marc.VBEAZ AS ShippingProcessingTime_VBEAZ,
-- marc.LIZYK AS Deactivated_LIZYK,
-- marc.BWSCL AS SourceOfSupply_BWSCL,
-- marc.KAUTB AS IndicatorAutomaticPurchaseOrderAllowed_KAUTB,
-- marc.KORDB AS IndicatorSourceListRequirement_KORBD,
-- marc.STAWN AS CommodityCodeImportCodeNumberForForeignTrade_STAWN,
-- marc.HERKL AS CountryOfOriginOfMaterial_HERKL,
-- marc.HERKR AS RegionOfOriginOfMaterial_HERKR,
-- marc.EXPME AS UnitOfMeasureForCommodityCode_EXPME,
-- marc.MTVER AS MaterialGroupExportForForeignTrade_MTVER,
-- marc.PRCTR AS ProfitCenter_PRCTR,
-- marc.TRAME AS StockInTransit_TRAME,
-- marc.MRPPP AS PPCPlanningCalendar_MRPPP,
-- marc.SAUFT AS IndRepetitiveMfgAllowed_SAUFT,
-- marc.FXHOR AS PlanningTimeFence_FXHOR,
-- marc.VRMOD AS ConsumptionMode_VRMOD,
-- marc.VINT1 AS ConsumptionPeriodBackward_VINT1,
-- marc.VINT2 AS ConsumptionPeriodForward_VINT2,
-- marc.VERKZ AS VersionIndicator_VERKZ,
-- marc.STLAL AS AlternativeBOM_STLAL,
-- marc.STLAN AS BOMUsage_STLAN,
-- marc.PLNNR AS KeyForTaskListGroup_PLNNR,
-- marc.APLAL AS GroupCounter_APLAL,
-- marc.LOSGR AS LotSizeForProductCosting_LOSGR,
-- marc.SOBSK As SpecialProcurementTypeForCosting_SOBSK,
-- marc.FRTME AS ProductionUnit_FRTME,
-- marc.LGPRO AS IssueStorageLocation_LGPRO,
-- marc.DISGR AS MRPGroup_DISGR,
-- marc.KAUSF AS ComponentScrapInPercent_KAUSF,
-- marc.QZGTP AS CertificateType_QZGTP,
-- marc.QMATV AS InspectionSetupExistsFor_MaterialPlant_QMATV,
-- marc.TAKZT AS TaktTime_TAKZT,
-- marc.RWPRO AS RangeOfCoverageProfile_RWPRO,
-- marc.COPAM AS LocalFieldNameForCOPALinkToSOP_COPAM,
-- marc.ABCIN AS PhysicalInventoryIndicatorForCycleCounting_ABCIN,
-- marc.AWSLS AS VarianceKey_AWSLS,
-- marc.SERNP AS SerialNumberProfile_SERNP,
-- marc.CUOBJ AS InternalObjectNumber_CUOBJ,
-- marc.STDPD AS ConfigurableMaterial_STDPD,
-- marc.SFEPR AS RepetitiveManufacturingProfile_SFEPR,
-- marc.XMCNG AS NegativeStocksAllowedInPlant_XMCNG,
-- marc.QSSYS AS RequiredQMSystemForVendor_QSSYS,
-- marc.LFRHY AS PlanningCycle_LFRHY,
-- marc.RDPRF AS RoundingProfile_RDPRF,
-- marc.VRBMT AS ReferenceMaterialForConsumption_VRBMT,
-- marc.VRBWK AS ReferencePlantForConsumption_VRBWK,
-- marc.VRBDT AS ToDateOfTheMaterialToBeCopiedForConsumption_VRBDT,
-- marc.VRBFK AS MultiplierForReferenceMaterialForconsumption_VRBFK,
-- marc.AUTRU AS ResetForecastModelAutomatically_AUTRU,
-- marc.PREFE AS PreferenceIndicatorInExportImport_PREFE,
-- marc.PRENC AS ExemptionCertificateIndicatorForLegalControl_PRENC,
-- marc.PRENO AS ExemptionCertificateNumberForLegalControl_PRENO,
-- marc.PREND AS ExemptionCertificateIssueDateOfExemptionCertificate_PREND,
-- marc.PRENE AS IndicatorVendorDeclarationExists_PRENE,
-- marc.PRENG AS ValidityDateOfVendorDeclaration_PRENG,
-- marc.ITARK AS IndicatorMilitaryGoods_ITARK,
-- marc.SERVG AS ISRServiceLevel_SERVG,
-- marc.KZKUP AS IndicatorMaterialCanBeCoProduct_KZKUP,
-- marc.STRGR AS PlanningStrategyGroup_STRGR,
-- marc.CUOBV AS InternalObjectNumberOfConfigurableMaterialForPlanning_CUOBV,
-- marc.LGFSB AS DefaultStorageLocationForExternalProcurement_LGFSB,
-- marc.SCHGT AS IndicatorBulkMaterial_SCHGT,
-- marc.CCFIX AS CCIndicatorIsFixed_CCFIX,
-- marc.EPRIO AS StockDeterminationGroup_EPRIO,
-- marc.QMATA AS MaterialAuthorizationGroupForActivitiesInQM_QMATA,
-- marc.RESVP AS PeriodOfAdjustmentForPlannedIndependentRequirements_RESVP,
-- marc.PLNTY AS TaskListType_PLNTY,
-- marc.UOMGR AS UnitOfMearsureGroup_UOMGR,
-- marc.UMRSL AS ConversionGroup_UMRSL,
-- marc.ABFAC AS AirBouyancyFactor_ABFAC,
-- marc.SFCPF AS ProductionSchedulingProfile_SFCPF,
-- marc.SHFLG AS SafetyTimeIndicator_SHFLG,
-- marc.SHZET AS SafetyTime_SHZET,
-- marc.MDACH AS ActionControlPlannedOrderProcessing_MDACH,
-- marc.KZECH AS DeterminationOfBatchEntryInTheProductionProcessOrder_KZECH,
-- marc.MEGRU AS UnitOfMeasureGroup_MEGRU,
-- marc.MFRGR AS MaterialFreightGroup_MFRGR,
-- marc.VKUMC AS StockTransferSalesValueForVOMaterial_VKUMC,
-- marc.VKTRW AS TransitValueAtSalesPriceForValueOnlyMaterial_VKTRW,
-- marc.KZAGL AS IndicatorSmoothPromotionConsumption_KZAGL,
-- marc.FVIDK AS ProductionVersionToBeCosted_FVIDK,
-- marc.FXPRU AS FixedPriceCoProduct_FXPRU,
-- marc.LOGGR AS LogisticsHandlingGroupForWorkloadCalculation_LOGGR,
-- marc.FPRFM AS DistributionProfileOfMaterialInPlant_FPRFM,
-- marc.GLGMG AS TiedEmptiesStock_GLGMG,
-- marc.VKGLG AS SalesValueOfTiedEmptiesStock_VKGLG,
--marc.INDUS AS MaterialCFOPCategory_INDUS,
--marc.MOWNR AS CAPNumberOfCAPProductsList_MOWNR,
--marc.MOGRU  AS CommonAgriculturalPolicyCAPProductsGroupForeignTrade_MOGRU,
--marc.CASNR  AS CASNumberPorPharmaceuticalProductsInForeignTrade_CASNR,
--marc.GPNUM  AS ProductionStatisticsPRODCOMNumberForForeignTrade_GPNUM,
--marc.STEUC  AS ControlCodeForConsumptionTaxesInForeignTrade_STEUC,
--marc.FABKZ  AS IndicatorItemRelevantToJITDeliverySchedules_FABKZ,
--marc.MATGR  AS GroupOfMaterialsForTransitionMatrix_MATGR,
--marc.VSPVB  AS ProposedSupplyAreaInMaterialMasterRecord_VSPVB,
--marc.DPLFS  AS FairShareRule_DPLFS,
--marc.DPLPU  AS IndicatorPushDistribution_DPLPU,
--marc.DPLHO  AS DeploymentHorizonInDays_DPLHO,
--marc.MINLS  AS MinimumLotSizeForSupplyDemandMatch_MINLS,
--marc.MAXLS  AS MaximumLotSizeForSupplyDemandMatch_MAXLS,
--marc.FIXLS AS FixedLotSizeForSupplyDemandMatch_FIXLS,
--marc.LTINC AS LotSizeIncrementForSupplyDemandMatch_LTINC,
--marc.COMPL AS ThisFieldIsNoLongerUsed_COMPL,
--marc.CONVT AS ConversionTypesForProductionFigures_CONVT,
--marc.SHPRO AS PeriodProfileForSafetyTime_SHPRO,
--marc.AHDIS AS MRPRelevancyForDependentRequirements_AHDIS,
--marc.DIBER AS IndicatorMRPAreaExists_DIBER,
--marc.KZPSP AS IndicatorForCrossProjectMaterial_KZPSP,
--marc.OCMPF AS OverallProfileForOrderChangeManagement_OCMPF,
--marc.APOKZ AS IndicatorIsMaterialRelevantForAPO_APOKZ,
--marc.MCRUE AS MARDHRecAlreadyExistsForPerBeforeLastOfMARDPer_MCRUE,
--marc.LFMON AS CurrentPeriod_LFMON,
--marc.LFGJA AS FiscalYearOfCurrentPeriod_LFGJA,
--marc.EISLO AS MinimumSafetyStock_EISLO,
--marc.NCOST  As DoNotCost_NCOST,
--marc.ROTATION_DATE  AS StrategyForPutawayAndStockRemoval_ROTATION_DATE,
--marc.UCHKZ  AS IndicatorForOriginalBatchManagement_UCHKZ,
--marc.UCMAT  AS ReferenceMaterialForOriginalBatches_UCMAT,
--marc.BWESB  AS ValuatedGoodsReceiptBlockedStock_BWESB,
--marc.SGT_COVS AS SegmentationStrategy_SGT_COVS,
--marc.SGT_STATC  As SegmentationStatus_SGT_STATC,
--marc.SGT_SCOPE  AS SegmentationStrategyScope_SGT_SCOPE,
--marc.SGT_MRPSI  AS SortStockBasedOnSegment_SGT_MRPSI,
--marc.SGT_PRCM AS ConsumptionPriority_SGT_PRCM,
--marc.SGT_CHINT  AS DiscreteBatchNumber_SGT_CHINT,
--marc.SGT_STK_PRT  AS StockProtectionIndicator_SGT_STK_PRT,
--marc.SGT_DEFSC  AS DefaultStockSegmentValue_SGT_DEFSC,
--marc.SGT_MRP_ATP_STATUS AS ATPMRPStatusForMaterialAndSegment_SGT_MRP_ATP_STATUS,
--marc.SGT_MMSTD  AS DateFromWhichThePlantSpecificMaterialStatusIsValid_SGT_MMSTD,
--marc.FSH_MG_ARUN_REQ  AS OrderAllocationRun_FSH_MG_ARUN_REQ,
--marc.FSH_SEAIM  AS IndicatorSeasonActiveInInventoryManagement_FSH_SEAIM,
--marc.FSH_VAR_GROUP  AS VariantGroup_FSH_VAR_GROUP,
--marc.FSH_KZECH  AS IndicatorBatchAssignmentDuringTRToTOConversion_FSH_KZECH,
--marc.FSH_CALENDAR_GROUP AS CalendarGroup_FSH_CALENDAR_GROUP,
--marc.PPSKZ  AS AdvancedPlanning_PPSKZ,
--marc.PPS_STRATEGY AS PPDSProposedStrategy_PPS_STRATEGY,
--marc.PPS_PLANNING_TYPE  AS PlanningProcedure_PPS_PLANNING_TYPE,
--marc.PPS_HEUR_ID  AS ProductHeuristicID_PPS_HEUR_ID,
--marc.PPS_FIXPEG AS FixedPegging_PPS_FIXPEG,
--marc.PPS_PEG_STRATEGY AS PeggingStrategy_PPS_PEG_STRATEGY,
--marc.PPS_GRPRT  AS GoodsReceiptProcessingTime_PPS_GRPRT,
--marc.PPS_GIPRT  AS GoodsIssueProcessingTime_PPS_GIPRT,
--marc.PPS_CONHAP AS HandlingCapacityConsumptionInUnitOfMeasure_PPS_CONHAP,
--marc.PPS_HUNIT  AS UnitOfMeasureHandlingCapacityInGoodsReceipt_PPS_HUNIT,
--marc.PPS_CONHAP_OUT AS HandlingCapacityConsumptionInUnitOfMeasure_PPS_CONHAP_OUT,
--marc.PPS_HUNIT_OUT  AS UnitOfMeasureHandlingCapacityInGoodsIssue_PPS_HUNIT_OUT,
--marc.PPS_ATPCHECK AS AdvancedPlanningATPCheck_PPS_ATPCHECK,
--marc.PPS_PEG_FUT_AL AS AlertThresholdForEarlyReceipts_PPS_PEG_FUT_AL,
--marc.PPS_PEG_PAST_AL  AS AlertThresholdForDelayedReceipts_PPS_PEG_PAST_AL,
--marc.SAPMP_TOLPRPL  AS PercentageTolerancePlus_SAPMP_TOLPRPL,
--marc.SAPMP_TOLPRMI  AS PercentageToleranceMinus_SAPMP_TOLPRMI,
--marc.VSO_R_PKGRP  AS PackingGroupOfTheMaterial_VSO_R_PKGRP,
--marc.VSO_R_LANE_NUM AS LineWithinTheAutomaticPickingZone_VSO_R_LANE_NUM,
--marc.VSO_R_PAL_VEND AS MaterialNoOfThePackagingMaterialOfTheVendor_VSO_R_PAL_VEND,
--marc.VSO_R_FORK_DIR AS PickPackagingMaterialsOnlyLengthwise_VSO_R_FORK_DIR,
--marc.IUID_RELEVANT  AS IUIDRelevant_IUID_RELEVANT,
--marc.IUID_TYPE  AS StructureTypeOfUII_IUID_TYPE,
--marc.UID_IEA  AS ExternalAllocationOfUII_UID_IEA,
--marc.CONS_PROCG AS ConsignmentControl_CONS_PROCG,
--marc.GI_PR_TIME AS GoodsIssueProcessingTimeInDays_GI_PR_TIME,
--marc.MULTIPLE_EKGRP AS PurchasingAcrossPurchasingGroup_MULTIPLE_EKGRP,
--marc.REF_SCHEMA AS ReferenceDeterminationSchema_REF_SCHEMA,
--marc.MIN_TROC AS MinimumTargetRangeOfCoverage_MIN_TROC,
--marc.MAX_TROC AS MaximumTargetRangeOfCoverage_MAX_TROC,
--marc.TARGET_STOCK AS TargetStock_TARGET_STOCK
FROM `{{ project_id_src }}.{{ dataset_cdc_processed_ecc }}.marc` AS marc
