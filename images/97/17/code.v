module top_module(
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    input C,
    output reg [3:0] q
);always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            // Simple addition/subtraction based on C
            if (C) begin
                q <= A - B; // Perform subtraction if C is set
            end else begin
                q <= A + B; // Perform addition if C is not set
            end
        end
    end
endmodule