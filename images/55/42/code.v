module top_module(D,clk,Q,NotQ);input D, clk;
output Q, NotQ;

wire w1,w2,w3,w4,w5;

assign w1 = (~D);
assign w2 = (clk & D);
assign w3 = (w1 & clk);
assign w4 = ~(w3 | w5);
assign w5 = ~(w4 | w2);

assign Q = w4;
assign NotQ = w5;

endmodule