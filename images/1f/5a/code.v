module odd_parity_generator(
    input [n-1:0] data,
    output reg parity
);
    parameter n = 5; // Example for 5-bit input
    always @(*) begin
        parity = ^data; // XOR reduction for odd parity
    end
endmodule