class item {
  int price;
  int amount;
  boolean previous = true;
  int rand;
  int rarity;
  public item(int price, int amount, int rarity) {
    this.price = price;
    this.amount = amount;
    this.rarity = rarity;
  }
  
  void update()
  {
    if(price == 0)
    {
      price+=rarity;
      previous = true;
    }
    else if(previous == true)
    {
       rand = round(random(0, 5));
       if(rand <= 3)
       {
         price+=rarity;
         previous = true;
       }
       else
       {
         price-=rarity/2;
         previous = false;
       }
    }
    else
    {
      rand = round(random(0, 5));
      if(rand <=3)
      {
        price-=rarity/2;
        previous =false;
      }
      else
      {
        price+=rarity;
        previous = true;
      }
    }
    
  }
  int getPrice()
  {
    return price;
  }
  
  void addAmount(int num)
  {
    amount+=num;
  }
  
  int getAmount()
  {
    return amount;
  }
}
