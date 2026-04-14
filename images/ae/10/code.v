module top_module(
    input clk,
    input reset,
    output reg [15:0] lfsr
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            lfsr <= 16'h1;  // Synchronous reset to a non-zero value
        end else begin
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};  // LFSR feedback polynomial
        end
    end

endmodule