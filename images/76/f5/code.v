module top_module(
    input clk,
    input reset,
    input [2:0] data,
    output reg parity
);

    always @(posedge clk) begin
        if (reset) begin
            parity <= 1'b0;  // Synchronous reset to the initial state
        end else begin
            parity <= data[0] ^ data[1] ^ data[2];  // Generate even parity
        end
    end

endmodule