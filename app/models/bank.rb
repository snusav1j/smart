class Bank < ApplicationRecord
  BANK_TBANK = 1
  BANK_SBER = 2
  BANK_ALFA = 3
  BANK_OZON = 4

  BANKS = [BANK_TBANK, BANK_SBER, BANK_ALFA, BANK_OZON]
end