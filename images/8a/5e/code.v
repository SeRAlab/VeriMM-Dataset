module top_module(
    input clk,
    input reset,
    input enable,
    input [7:0] data_in,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the register to 8'b00000000
            q <= 8'b00000000;
        end else if (enable) begin
            // Hold operation: Hold data_in in the register when enable is high
            q <= data_in;
        end
    end

endmodule