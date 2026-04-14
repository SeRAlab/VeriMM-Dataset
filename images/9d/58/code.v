module top_module(
    input clk,
    input reset_n,
    input load,
    input [7:0] data_in,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the register to 8'b00000000
            q <= 8'b00000000;
        end else if (load) begin
            // Load operation: Load data_in into the register when load is high
            q <= data_in;
        end
    end

endmodule