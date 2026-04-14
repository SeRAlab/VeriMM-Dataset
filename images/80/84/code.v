module top_module( clk,
                 clk__enable,
                 reset_n,
                 switches,
                 leds);input clk;
   input clk__enable;
   input reset_n;

   input [3:0]  switches;
   output [7:0] leds;

   reg [7:0]    leds;
   reg [31:0]   counter;
   
   always @(negedge reset_n or posedge clk)
     begin
        if (!reset_n)
          begin
             counter <= 0;
             leds <= 0;
          end
        else if (clk__enable)
          begin
             counter <= counter + 1;
             if (counter[27])
               begin
                  counter<=0;
                  if (switches[1])
                    begin
                       leds <= leds + 1;
                    end
               end
          end
     end

endmodule