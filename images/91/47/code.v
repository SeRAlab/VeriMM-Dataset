module top_module(
    input clk,
    input reset,
    input [2:0] data,
    output reg parity_error
);

    always @(posedge clk) begin
        if (reset) begin
            parity_error <= 1'b0;  // Synchronous reset to the initial state
        end else begin
            parity_error <= ~(data[0] ^ data[1] ^ data[2]);  // Check odd parity
        end
    end

endmodule