module top_module(LEDS, SWITCHES,CLK,RESET);input [1:0] SWITCHES;
        output [3:0] LEDS;
     
       reg [3:0] LEDS;
        input CLK;
        input RESET;
   
 
        reg clkout;   
       reg [27:0] counter;
   
    always@(posedge CLK)
       begin
 
                   counter <= counter + 1;
                   if ( counter == 125_000_000)
                       begin
                           counter <= 0;
                           clkout <= ~clkout;
                       end
               end
 
 always @ (posedge clkout )
 begin

        if (RESET ==1)
        LEDS[3:0]=4'b0000; 
        if (SWITCHES[0]==1)
        LEDS[3:0]= LEDS[3:0] + 1'b1;
        if (SWITCHES[1]==1)
        LEDS[3:0]= LEDS[3:0] - 1'b1;
       
 end       
endmodule