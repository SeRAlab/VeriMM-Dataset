module top_module(ER_CDE, clk, HEX0, HEX1, HEX2, HEX3, HEX1DP);input[7:0] ER_CDE;
input clk;
output reg[6:0] HEX0, HEX1, HEX2, HEX3;
output reg HEX1DP;

always @(posedge clk) begin

case (ER_CDE[7:0])

8'b00000000: begin 

HEX0 = 7'b0000000;
HEX1 = 7'b0000000;
HEX2 = 7'b0000000;
HEX3 = 7'b0000000;
HEX1DP = 1'b0; end

8'b00000001: begin 

HEX0 = 7'b1111001;
HEX1 = 7'b1010000; 
HEX2 = 7'b0111111;
HEX3 = 7'b0000110;
HEX1DP = 1'b1; end

8'b00000010: begin 

HEX0 = 7'b1111001;
HEX1 = 7'b1010000; 
HEX2 = 7'b0111111;
HEX3 = 7'b1011011; 
HEX1DP = 1'b1; end

8'b00000011: begin 

HEX0 = 7'b1111001;
HEX1 = 7'b1010000; 
HEX2 = 7'b0111111;
HEX3 = 7'b1001111; 
HEX1DP = 1'b1; end

8'b00000100: begin 

HEX0 = 7'b1111001;
HEX1 = 7'b1010000; 
HEX2 = 7'b0111111;
HEX3 = 7'b1100110;
HEX1DP = 1'b1; end

8'b00000101: begin 

HEX0 = 7'b1111001;
HEX1 = 7'b1010000; 
HEX2 = 7'b0111111;
HEX3 = 7'b1101101;
HEX1DP = 1'b1; end

8'b00000110: begin 

HEX0 = 7'b1111001;
HEX1 = 7'b1010000; 
HEX2 = 7'b0111111;
HEX3 = 7'b1111101;
HEX1DP = 1'b1; end

endcase
end

endmodule