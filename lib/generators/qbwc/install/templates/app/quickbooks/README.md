# Quickbooks Integration
###### *In memory of my sanity* ######

## Most Important Information ##
Never use instance variables across methods that you are not explicitly calling. The qbwc gem creates a new instance for every single method call. \
If you need to persist Information use either data[(foo)] (Please keep data as a hash unless you are a masochist) or make a new instance of the respective entity action class to find a value.

## Index ##
+ Quickbooks Integration
    + [Most Important Information](#most-important-information)
    + [Index](#index)
    + [Dictionary](#dictionary)
    + [Structure](#structure)
    + [Current Progress](#current-progress)
    + [Important Variables](#important-variables)

## Dictionary ##
QBWC - The qbwc gem that this project is centered around. \
QBW - The **Q**uick**B**ooks **W**ebconnecter ( I didn't come up with these - thank Intuit ) \
Qb - Quickbooks \
QbC, QbI, QbP - Qb + [Company, Invoice, Payment] and so on. \
qbc - Same as QbC but different use case. (I.E. Instance instead of Class usually, also used as a method to create an instance) \
qbc_i - qb company's invoice \
qbp_ip_i - qb payment's invoice_payment's invoice ( It just gets worse. Basically just read it in whatever way makes it obey the plurality it should be.) \
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
            - [x] Del (Needs tweaking)
            - [ ] Query
        + QbI
        + Invoices (Most actions depend on Company)
            - [x] Add 
            - [ ] Mod
            - [x] Del (Needs Tweaking)
            - [ ] Query
            - [ ] Void
        + QbP
        + Payments (Most actions depend on Company && Invoice)
            - [x] Add
            - [ ] Mod
            - [x] Del (Needs Tweaking)
            - [ ] Query
            - [ ] Void
            
### Important Variables ##
##### Entity Class #####
    @qb_entity = String; Qb name for the entity. (CamelCase)
    @t2_entity = Class; The T2 Model's Class
    @t2_instance = Object; An instance of t2_entity found using a supplied ID.
    