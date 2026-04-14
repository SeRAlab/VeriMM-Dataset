module odd_parity_generator (
    input [3:0] data_in,
    output reg parity_out
);

always @(*) begin
    parity_out = ^data_in; // XOR reduction to determine parity
end

endmodule