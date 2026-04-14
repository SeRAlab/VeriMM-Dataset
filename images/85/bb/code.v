module top_module( input clock,
    input reset,
    input enable,
    input [7:0] rate,
    output wire sync );reg [7:0] counter;
   assign sync = |(((rate+1)>>1)& counter);
      
   always @(posedge clock)
     if(reset || ~enable)
       counter <= #1 0;
     else if(counter == rate)
       counter <= #1 0;
     else 
       counter <= #1 counter + 8'd1;
   
endmodule