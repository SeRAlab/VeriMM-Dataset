module binary_decoder(BIN, DEC);
input [1:0] BIN;
output [3:0] DEC;
reg [3:0] DEC;

always @(BIN) begin
    case (BIN)
        2'b00: DEC = 4'b0001; // 0
        2'b01: DEC = 4'b0010; // 1
        2'b10: DEC = 4'b0100; // 2
        2'b11: DEC = 4'b1000; // 3
        default: DEC = 4'b0000; // default case
    endcase
end

endmodule