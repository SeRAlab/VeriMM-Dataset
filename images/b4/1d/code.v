module top_module(input clk, reset, input [7 : 0] d, output reg [7 : 0] q);always @ (posedge clk, posedge reset)
        if(reset) q <= 0;
       
        else q <= d;
endmodule