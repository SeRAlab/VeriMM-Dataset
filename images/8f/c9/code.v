module binary_decoder_3to8(
    input           clk,
    input           reset,
    input           enable,
    input   [2:0]   binary_in,

    output reg [7:0] onehot_out
);

always @(*)
begin
    if (reset || !enable) begin
        onehot_out = 8'b00000000;
    end else begin
        case (binary_in)
            3'b000: onehot_out = 8'b00000001;
            3'b001: onehot_out = 8'b00000010;
            3'b010: onehot_out = 8'b00000100;
            3'b011: onehot_out = 8'b00001000;
            3'b100: onehot_out = 8'b00010000;
            3'b101: onehot_out = 8'b00100000;
            3'b110: onehot_out = 8'b01000000;
            3'b111: onehot_out = 8'b10000000;
            default: onehot_out = 8'b00000000;
        endcase
    end
end

endmodule