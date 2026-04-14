module top_module(
    input [15:0] A,
    input [15:0] B,
    input MODE,
    input CIN,
    input clk,        // Added missing clock input
    input reset,      // Added missing reset input
    output reg [15:0] Q
);reg [15:0] sum;
reg [15:0] diff;
reg carry;

always @(posedge clk) begin
    if (reset) begin
        sum <= 16'b0;
        diff <= 16'b0;
        carry <= 1'b0;
        Q <= 16'b0;    // Reset output
    end else begin
        if (MODE == 0) begin
            {carry, sum} <= A + B + carry; // Update carry and sum properly
            Q <= sum;
        end else begin
            {carry, diff} <= A - B - carry; // Update carry and diff properly
            Q <= diff;
        end
    end
end

endmodule