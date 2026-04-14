module top_module(add, set_hour, set_minute, hour2, hour1, minute2, minute1, second2, second1);input add, set_hour, set_minute; 
  output reg [3:0] hour2, hour1, minute2, minute1, second2, second1; 
  always @(posedge add) 
  begin 
  if(set_minute & ~set_hour) 
  begin 
  minute1 <= minute1 + 1; 
  if (minute1 > 8) 
  begin 
  minute2 <= minute2 + 1; 
  minute1 <= 0; 
  end 
  if (minute2 > 5) 
  minute2 <= 0; 
  if((minute2 == 5)&(minute1 == 9)) 
  begin 
  minute2 <= 0; 
  minute1 <= 0; 
  end 
  end 
  else if (~set_minute & set_hour) 
  begin 
  hour1 <= hour1 + 1; 
  if (hour1 > 8) 
  begin 
  hour2 <= hour2 + 1; 
  hour1 <= 0; 
  end 
  if (hour2 == 2) 
  if (hour1 > 2) 
  begin 
  hour2 <= 0; 
  hour1 <= 0; 
  end 
  end 
  else ; 
  end 
 endmodule