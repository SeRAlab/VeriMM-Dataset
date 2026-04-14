module top_module(
    input clk,
    input reset,
    input load,
    input [15:0] data_in,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the register to 16'b0000000000000000
            q <= 16'b0000000000000000;
        end else if (load) begin
            // Load operation: Load data_in into the register when load is high
            q <= data_in;
        end
    end

endmodule