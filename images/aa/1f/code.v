module fibonacci_lfsr (
    input clk,
    input reset,
    output reg [11:0] lfsr
);

    always @(posedge clk) begin
        if (reset) begin
            lfsr <= 12'b000000000001; // Non-zero seed
        end else begin
            lfsr <= {lfsr[10:0], lfsr[11] ^ lfsr[10]};
        end
    end

endmodule