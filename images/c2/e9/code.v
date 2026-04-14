module fix_shifter(
    output [31:0] dout,
    input [31:0] B,
    input [1:0] ctrl,
    input [1:0] A
);

wire [31:0] shifted;

assign shifted = (ctrl == 2'b00) ? (B << A) :
                 (ctrl == 2'b01) ? (B << (A + 1)) :
                 (ctrl == 2'b10) ? (B << (A + 2)) :
                                   (B << (A + 3));
assign dout = shifted;

endmodule