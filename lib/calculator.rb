class Calculator

  require 'date'

  VAT = 0.05

  attr_reader :price,
              :threshold,
              :price_results,
              :usage,
              :spend

  def initialize 
    @price = 0
    @threshold = 0
    @price_results = []
    @usage = 0
    @spend = 0
  end

  def calculate_prices (usage, plans)
    plans.each do |plan|
      calculate_plan_price(usage, plan[:rates])
      add_standing_charge(plan) if plan.key?(:standing_charge)
      add_vat(@price)
      @price = (@price/100).round(2)
      @price_results << { supplier: plan[:supplier], plan: plan[:plan], price: @price }
      @price = 0
      @threshold = 0
    end
    puts output_price_results(@price_results)
    @price_results = []
  end

  def calculate_plan_price (usage, rates)
    rates.each do |rate|
      if rate.key?(:threshold)
         @price = @price + (rate[:price]*rate[:threshold])
         @threshold = @threshold + rate[:threshold]
      else
        @price = @price + rate[:price]*(usage-threshold)
      end
    end
  end

  def output_price_results (price_results)
    price_results.sort_by! { |k| k[:price] }
    price_results.collect { |k| "#{k[:supplier]},#{k[:plan]},#{k[:price]}" }
  end

  def calculate_usage (supplier, plan, spend, plans)
    evaluated_plan = plans.select { |e| e[:supplier] == supplier && e[:plan] == plan }
    standing_charge = evaluated_plan[0][:standing_charge]
    annual_spend = subtract_vat(spend*100*12)
    (annual_spend = subtract_standing_charge(annual_spend, standing_charge)) if standing_charge
    evaluated_plan[0][:rates].each do |rate|
      if rate.key?(:threshold)
        @spend = @spend + (rate[:price]*rate[:threshold])
        @threshold = @threshold + rate[:threshold]
      else
        @usage = ((annual_spend - @spend)/rate[:price] + @threshold).round
        puts @usage
      end
    end
    @usage = 0
    @spend = 0
    @threshold = 0
  end

  def leap_year?
    year = Date.today.year
    Date.leap?(year)
  end

  def add_standing_charge (plan)
    leap_year? ? days = 366 : days = 365
    @price = @price + (plan[:standing_charge]*days)
  end

  def subtract_standing_charge(spend, standing_charge)
    leap_year? ? days = 366 : days = 365
    spend = spend - (standing_charge*days)
  end

  def add_vat (sum)
    @price = sum*(1+VAT)
  end

  def subtract_vat (sum)
    @price = (sum/((1+VAT)*100))*100
  end

end