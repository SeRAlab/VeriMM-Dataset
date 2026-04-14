module binary_decoder(
    input           clk,
    input           reset,
    input           enable,
    input   [1:0]   binary_in,

    output reg [3:0] onehot_out
);

always @(*)
begin
    if (reset || !enable) begin
        onehot_out = 4'b0000;
    end else begin
        case (binary_in)
            2'b00: onehot_out = 4'b0001;
            2'b01: onehot_out = 4'b0010;
            2'b10: onehot_out = 4'b0100;
            2'b11: onehot_out = 4'b1000;
            default: onehot_out = 4'b0000;
        endcase
    end
end

endmodule