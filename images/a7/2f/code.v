module parity_gen8(
    input [7:0] data_in,
    output reg parity_out
);

always @(*) begin
    parity_out = ^data_in; // XOR all bits to generate even parity
end

endmodule