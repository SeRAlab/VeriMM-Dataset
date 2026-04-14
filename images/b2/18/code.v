module fibonacci_lfsr (
    input clk,
    input enable,
    output reg [5:0] lfsr
);always @(posedge clk) begin
        if (enable)
            lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[3]};
    end

endmodule