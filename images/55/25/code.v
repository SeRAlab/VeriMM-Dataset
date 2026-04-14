module top_module (
    input [15:0] in,
    output reg parity
);

    always @(*) begin
        parity = ^in; // XOR reduction to calculate parity
    end

endmodule