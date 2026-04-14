module binary_decoder(BIN_IN, DEC_OUT);
input [1:0] BIN_IN;
output [3:0] DEC_OUT;
reg [3:0] DEC_OUT;

always @(BIN_IN) begin
    case (BIN_IN)
        2'b00: DEC_OUT = 4'b0001;
        2'b01: DEC_OUT = 4'b0010;
        2'b10: DEC_OUT = 4'b0100;
        2'b11: DEC_OUT = 4'b1000;
        default: DEC_OUT = 4'b0000;
    endcase
end

endmodule