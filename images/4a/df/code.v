module top_module(clk,reset,cmd,red,yellow,green,left);input clk, reset;
input [2:0] cmd;
output red,yellow,green,left;

reg red,yellow,green,left;

always@(posedge clk)
begin
if (reset)
  begin

red =1;
yellow=0;
green=0;
left=0;
  end
else
  begin

if (cmd==0)
   begin
  
   red=1;
   yellow=0;
   green=0;
   left=0;
   end
else if (cmd==1)
   begin
  
   green=0;
   yellow=1;
   red=0;
   left=0;
   end
else if(cmd==2)
  begin
  
   red=0;
   yellow=0;
   green=1;
   left=0;
  end
else if(cmd==3)
  begin
   
   red=0;
   yellow=0;
   green=1;
   left=1;
  
  end
else if(cmd==4)
   begin
    
   red=0;
   yellow=1;
   green=1;
   left=0;
   end
else
  begin
  red =1;
yellow=0;
green=0;
left=0;

  end

  end


end


endmodule