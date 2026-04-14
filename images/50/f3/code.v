module mux_2to1_8bit(IN0, IN1, SEL, OUT);
input [7:0] IN0, IN1;
input SEL;
output [7:0] OUT;

assign OUT = (SEL) ? IN1 : IN0;

endmodule