module top_module(PIN1, PIN2, GIN1, GIN2, PHI, POUT, GOUT);input PIN1;
input PIN2;
input GIN1;
input GIN2;
input PHI;
output POUT;
output GOUT;

wire and1;
wire and2;
wire or1;

assign and1 = PIN1 & PIN2;
assign and2 = PIN2 & GIN1;
assign or1 = GIN2 | and2;

assign POUT = ~and1;
assign GOUT = ~or1;

endmodule