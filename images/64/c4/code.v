module top_module(
    input clk,          // Clock input
    input reset,        // Synchronous active-high reset
    input select,       // Select input to choose between minimum circuit and register shift module
    input [7:0] a, b, c, d,      // Input for the minimum circuit
    input [1:0] ena,    // Input for register shift module to choose shift direction
    input [99:0] data,  // Input for register shift module to load data
    output reg [7:0] min,        // Output for the minimum circuit
    output reg [99:0] q         // Output for the register shift module
);// 4-way minimum circuit
reg [7:0] min1, min2, min3;

always @* begin
    min1 = (a < b) ? a : b;
    min2 = (c < d) ? c : d;
    min3 = (min1 < min2) ? min1 : min2;
end

always @(posedge clk) begin
    if (reset) begin
        min <= 8'd0;
    end else if (select) begin
        min <= min3;
    end else begin
        // Register shift module
        if (ena == 2'b00) begin
            // Shift left
            q <= {q[98:0], 1'b0};
        end else if (ena == 2'b01) begin
            // Shift right
            q <= {1'b0, q[99:1]};
        end else if (ena == 2'b10) begin
            // Load data
            q <= data;
        end
        min <= 8'd0;
    end
end

endmodule