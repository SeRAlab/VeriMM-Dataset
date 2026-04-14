module bin_to_onehot(BIN, ONEHOT);
input [2:0] BIN;
output reg [7:0] ONEHOT;

always @(*) begin
    ONEHOT = 8'b00000000;
    case (BIN)
        3'b000: ONEHOT[0] = 1;
        3'b001: ONEHOT[1] = 1;
        3'b010: ONEHOT[2] = 1;
        3'b011: ONEHOT[3] = 1;
        3'b100: ONEHOT[4] = 1;
        3'b101: ONEHOT[5] = 1;
        3'b110: ONEHOT[6] = 1;
        3'b111: ONEHOT[7] = 1;
    endcase
end

endmodule