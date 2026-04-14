module top_module(a , b , carryin , sum , carryout);input a,b,carryin;
output sum,carryout;
wire w1,w2,w3;

assign w1 = a ^ b;
assign w2 = a & b;
assign sum = carryin ^ w1;
assign w3 = w1 & carryin;
assign carryout = w2 + w3;

endmodule