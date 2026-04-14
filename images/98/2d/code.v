module top_module(SW, LEDR);input   [7:0]   SW;
output  [9:0]   LEDR;

wire    [3:0]   y;
wire    [7:0]   x;


assign x = SW;

assign y[0] = x[0] ^ x[4];
assign y[1] = x[1] ^ x[5];
assign y[2] = x[2] ^ x[6];
assign y[3] = x[3] ^ x[7];

assign LEDR[0] = ~|(y);


endmodule