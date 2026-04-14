module bin2_to_onehot(
    input [1:0] bin_in,
    output reg [3:0] onehot_out
);

always @(*) begin
    case(bin_in)
        2'b00: onehot_out = 4'b0001; // 0
        2'b01: onehot_out = 4'b0010; // 1
        2'b10: onehot_out = 4'b0100; // 2
        2'b11: onehot_out = 4'b1000; // 3
        default: onehot_out = 4'b0000; // None
    endcase
end

endmodule