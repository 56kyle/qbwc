# Quickbooks Integration
*In memory of my sanity~*
```
    0x80040400: QuickBooks found an error when parsing the provided XML text stream.
```

## Most Important Information ##
Never use instance variables across methods that you are not explicitly calling. The qbwc gem creates a new instance for every single method call. \
If you need to persist Information use either data[(foo)] (Please keep data as a hash unless you are a masochist) or make a new instance of the respective entity action class to find a value.

## Index ##
+ [Quickbooks Integration](#quickbooks-integration)
    + [Most Important Information](#most-important-information)
    + [Index](#index)
    + [Dictionary](#dictionary)
    + [Structure](#structure)
    + [Current Progress](#current-progress)
    + [Important Variables](#important-variables)
        + [Entity Class](#entity-class)
    + [Logic Flow](#logic-flow)
        + [Example](#example)
    + [Changes Made During Install](#changes-made-during-install)
        + [Directories/Files](#directoriesfiles)
        + [Migrations](#migrations-in-dbmigrate)
        + [QBWC Other Changes](#qbwc-other-changes)

## Dictionary ##
**QBWC** - The qbwc gem that this project is centered around. \
**QBW** - The **Q**uick**B**ooks **W**ebconnecter ( I didn't come up with these - thank Intuit ) \
**Qb** - Quickbooks \
**QbC**, **QbI**, **QbP** - Qb + [Company, Invoice, Payment] and so on. \
**qbc** - Same as QbC but different use case. (I.E. Instance instead of Class usually, also used as a method to create an instance) \
**qbc_i** - qb company's invoice \
**qbp_ip_i** - qb payment's invoice_payment's invoice ( It just gets worse. Basically just read it in whatever way makes it obey the plurality it should be.) \
** Just as a note these chained names are mainly found deeper within the action classes.

## Structure ##
+ QBWC::Worker
    + Main Class < QBWC::Worker
        + Entity Classes < Main Class (includes respective entity actions module)
        + Entity Actions Modules
            + Action Classes < Entity Classes
            + ~~Action Modules~~ (These create way too much confusion.)
            
## Current Progress ##
+ QBWC::Worker
    + QbWorker (< QBWC::Worker)
        + includes Qb::[Companies, Invoices, Payments]
    + Qb
        + QbC (< QbWorker)
        + Companies
            - [x] Add
            - [x] Mod
            - [x] Del
            - [x] Query
        + QbI
        + Invoices (Most actions depend on Company)
            - [x] Add 
            - [x] Mod
            - [x] Del
            - [x] Query
            - [x] Void
        + QbP
        + Payments (Most actions depend on Company && Invoice)
            - [x] Add
            - [x] Mod
            - [x] Del
            - [x] Query
            - [ ] Void
            
## Important Variables ##
##### Entity Class #####
    @qb_entity = String; Qb name for the entity. (CamelCase)
    @t2_entity = Class; The T2 Model's Class
    @t2_instance = Object; An instance of t2_entity found using a supplied ID.
    
## Logic Flow ##
+ Same for every entity mostly. Only difference is Company doesn't have a Void action.
+ For readability I am going to omit any intermediate logic I can. This is just to get an idea of what certain actions will lead to eventually. Assume "~>" encompasses a couple steps.
#### Example ####
    new_invoice = Invoice.new(paid_amount: 1000).save ~> Qb::Invoices::Add.act(new_invoice)
    Qb::Invoices::Add.act(new_invoice) ~> QBWC.add_job(...) # Enters an entry into qbwc_jobs
    # Next step is prompted whenever QWC runs and sends a request to a predetermined link.
    (QBWC Gem) Qb::Invoices::Add.new.should_run?(job, session, data) ~>
    (T2) Qb::Invoices::Add:Object.should_run?(...) ~> (calls super do ... end or default)
    (T2) Qb::QbI:Object.should_run?(...) ~> (calls super do ... end or default)
    (T2) QbWorker:Object.should_run?(...) ~> (yields or default)
    (QBWC Gem) QBWC::Worker:Object.should_run?(...) ~>
This pattern is repeated in the following methods in the above mentioned classes:
+ initialize(data= nil) (*note- qbwc doesn't call new with parameters.*)
+ should_run?(job, session, data)
+ requests(job, session, data)
+ handle_response(response, session, job, request, data) (In that order, for whatever reason)

The reason that all of these call super is that at the top of the chain is QbWorker which initializes @t2_instance in every method call.
This allows us to avoid manually writing out 20 find_by's.
Additionally it allows guaranteeing handle_response always deletes the job on completion (assuming it doesn't error out).

## Changes Made During Install ##
I'm going to do my best to add everything here, but considering this needs to be ported to rails 4 it is liable to change.
+ ##### Directories/Files #####
    (In ~/app/)\
    Format: directory - [file, ...] (.rb not being shown)
    + quickbooks - [qb_worker, qb_hook, grammar, README]
        + qb - [qb_c, qb_i, qb_p]
            + companies - [add, mod, del, query, void(just contains nil)]
            + invoices - [add, mod, del, query, void] 
            + payments - [add, mod, del, query, void]
            
+ ##### Migrations (In ~/db/migrate/) #####
    + add_qb_id_to_payments.rb
    + add_qb_id_to_invoice_lines.rb
    + create_qbwc_jobs.rb
    + create_qbwc_sessions.rb
    + index_qbwc_jobs.rb
    + change_request_index.rb
    + session_pending_jobs_text.rb
    
+ ##### QBWC Other Changes #####
    + Adds an initializer
    + Adds a controller
    + Adds 3 routes

    
