module state_space_controller (
    input clk,
    input rst,
    input signed [15:0] x1,
    input signed [15:0] x2,
    input signed [15:0] u,
    output reg signed [15:0] x1_next,
    output reg signed [15:0] x2_next
);
    // Constants for state-space representation
    parameter signed [15:0] a11 = 16'h0002;
    parameter signed [15:0] a12 = 16'h0001;
    parameter signed [15:0] a21 = 16'h0001;
    parameter signed [15:0] a22 = 16'h0002;
    parameter signed [15:0] b1 = 16'h0001;
    parameter signed [15:0] b2 = 16'h0001;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1_next <= 16'h0000;
            x2_next <= 16'h0000;
        end else begin
            x1_next <= a11 * x1 + a12 * x2 + b1 * u;
            x2_next <= a21 * x1 + a22 * x2 + b2 * u;
        end
    end
endmodule