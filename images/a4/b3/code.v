module top_module(input clk, input clrb, input SDR, output reg [3:0]Q);always @ (posedge(clk), negedge(clrb))

if (~clrb) 
    Q<=4'b0000;
else 
    Q<={SDR, Q[3:1]};endmodule