module Qb
  class CustomEntity < QbWorker
    attr_accessor :qb_type, :qb_actions, :requests
    def initialize(qb_type, qb_actions)
      @qb_type = qb_type
      @qb_actions = qb_actions
    end
    def requests(job, session, data); @requests end
  end
  def qb_entity?(qb_entity)
    @possible.keys.include?(qb_entity)
  end
  def make_new(qb_entity)
    if qb_entity?(qb_entity)
      qb_actions = @possible[qb_entity.to_sym][:qb_actions]
      qb_type = @possible[qb_entity.to_sym][:qb_type]
      CustomEntity.new(qb_type, qb_actions)
    end
  end

  @possible = {                                   # :qb_actions => [add, mod, del, query, void]
      Account:                 {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      AgingReport:             {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      ARRefundCreditCard:      {:qb_type => "Txn", :qb_actions => [true, false, true, true, true]},
      Bill:                    {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      BillPaymentCheck:        {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      BillPaymentCreditCard:   {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      BillToPay:               {:qb_type => "Txn", :qb_actions => [false, false, false, true, false]},
      BillingRate:             {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      BudgetSummaryReport:     {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      BuildAssembly:           {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      Charge:                  {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      Check:                   {:qb_type => "Txn", :qb_actions => [true, false, true, true, true]},
      Class:                   {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      Company:                 {:qb_type => "Special", :qb_actions => [false, false, false, true, false]},
      CompanyActivity:         {:qb_type => "Special", :qb_actions => [false, false, false, true, false]},
      CreditCardCharge:        {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      CreditCardCredit:        {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      CreditMemo:              {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      Currency:                {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      CustomDetailReport:      {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      Customer:                {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      CustomerMessage:         {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      CustomerType:            {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      CustomSummaryReport:     {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      DataEventRecoveryInfo:   {:qb_type => "EventNotification", :qb_actions => [false, false, true, true, false]},
      DataEventSubscription:   {:qb_type => "EventNotification", :qb_actions => [true, false, true, true, false]},
      DataExt:                 {:qb_type => "Special", :qb_actions => [true, true, true, false, false]},
      DataExtDef:              {:qb_type => "Special", :qb_actions => [true, true, true, true, false]},
      DateDrivenTerms:         {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      Deposit:                 {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      DiscountItem:            {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      Employee:                {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      Entity:                  {:qb_type => "List", :qb_actions => [false, false, false, true, false]},
      Estimate:                {:qb_type => "Txn", :qb_actions => [true, true, true, true, false]},
      FixedAssetItem:          {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      GeneralDetailReport:     {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      GeneraSummaryReport:     {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      GroupItem:               {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      HostApplication:         {:qb_type => "Special", :qb_actions => [false, false, false, true, false]},
      InventoryAdjustment:     {:qb_type => "Txn", :qb_actions => [true, false, true, true, false]},
      InventoryAssemblyItem:   {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      InventoryItem:           {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      Invoice:                 {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      Item:                    {:qb_type => "List", :qb_actions => [false, false, false, true, false]},
      ItemReceipt:             {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      JobType:                 {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      JobReport:               {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      JournalEntry:            {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      ListDisplay:             {:qb_type => "UIIntegration", :qb_actions => [true, true, false, false, false]},
      NonInventoryItem:        {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      NonPagePayrollItem:      {:qb_type => "List", :qb_actions => [false, false, false, true, false]},
      OtherChargeItem:         {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      OtherName:               {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      PaymentItem:             {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      PaymentMethod:           {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      PayrollDetailReport:     {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      PayrollSummaryReport:    {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      Preferences:             {:qb_type => "Special", :qb_actions => [false, false, false, true, false]},
      PriceLevel:              {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      PurchaseOrder:           {:qb_type => "Txn", :qb_actions => [true, true, true, true, false]},
      ReceivePayment:          {:qb_type => "Txn", :qb_actions => [true, true, true, true, false]},
      ReceivePaymentToDeposit: {:qb_type => "Txn", :qb_actions => [false, false, false, true, false]},
      SalesOrder:              {:qb_type => "Txn", :qb_actions => [true, true, true, true, false]},
      SalesReceipt:            {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      SalesRep:                {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      SalesTaxCode:            {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      SalesTaxGroupItem:       {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      SalesTaxItem:            {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      SalesTaxPaymentCheck:    {:qb_type => "Txn", :qb_actions => [false, false, false, true, false]},
      ServiceItem:             {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      ShipMethod:              {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      SpecialAccount:          {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      SpecialItem:             {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      StandardTerms:           {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      SubtotalItem:            {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      Template:                {:qb_type => "List", :qb_actions => [false, false, false, true, false]},
      Terms:                   {:qb_type => "List", :qb_actions => [false, false, false, true, false]},
      TimeTracking:            {:qb_type => "Txn", :qb_actions => [true, false, true, true, false]},
      TimeReport:              {:qb_type => "Report", :qb_actions => [false, false, false, true, false]},
      Tod:                     {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      TransactionQuery:        {:qb_type => "Txn", :qb_actions => [false, false, false, true, false]},
      TxnDisplay:              {:qb_type => "UIIntegration", :qb_actions => [true, true, false, false, false]},
      UIEventSubscription:     {:qb_type => "EventNotification", :qb_actions => [true, false, true, true, false]},
      UIExtensionSubscription: {:qb_type => "EventNotification", :qb_actions => [true, false, true, true, false]},
      UnitOfMeasureSet:        {:qb_type => "List", :qb_actions => [false, false, true, true, false]},
      Vendor:                  {:qb_type => "List", :qb_actions => [true, true, true, true, false]},
      VendorCredit:            {:qb_type => "Txn", :qb_actions => [true, true, true, true, true]},
      VendorType:              {:qb_type => "List", :qb_actions => [true, false, true, true, false]},
      WagePayrollItem:         {:qb_type => "List", :qb_actions => [true, false, false, true, false]},
      WorkersCompCode:         {:qb_type => "List", :qb_actions => [true, true, false, true, false]}
  }
  @qb_item_codes =
      {
          '1' => 'Audit',
          '2' => 'Brands Fee',
          '3' => 'Brands Installment Fee',
          '4' => 'Cancellation Credit',
          '5' => 'Deposit',
          '6' => 'Endorsement',
          '7' => 'Inst Fee',
          '8' => 'Installment',
          '9' => 'Late Fee',
          '10' => 'Monthly Report',
          '11' => 'NSF Fee',
          '12' => 'Policy Premium',
          '13' => 'Quote',
          '14' => 'STC',
          '15' => 'Surety Bonds',
          '16' => 'Taxes',
          '17' => 'Previous Balance',
          '18' => 'Commission',
          '19' => 'Tiger Escrow Rollover',
          '20' => 'Escrow Rollover',
          '21' => 'SaferWatch Fee',
          '22' => 'Taxes-C',
          '23' => 'Reinstatement Fee',
          '24' => 'Policy Rec Premium',
          '25' => 'NC Reinsurance Facility Recoupment Fee',
          '26' => 'Reinstatment',
          '27' => 'Policy Rec Deposit'
      }
end
