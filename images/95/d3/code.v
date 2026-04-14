module top_module(input [1:0] S, input D0, input D1, input D2, input D3, input OE, output Y);wire Z0, Z1, Z2, Z3;

// Using tri-state buffer implementation
assign Z0 = (OE) ? D0 : 1'bz;
assign Z1 = (OE) ? D1 : 1'bz;
assign Z2 = (OE) ? D2 : 1'bz;
assign Z3 = (OE) ? D3 : 1'bz;

assign Y = (S == 2'b00) ? Z0 :
           (S == 2'b01) ? Z1 :
           (S == 2'b10) ? Z2 :
           (S == 2'b11) ? Z3 : 1'bz;

endmodule