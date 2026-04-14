module top_module(
    input clk,
    input reset,
    input [31:0] A,
    input [31:0] B,
    input d,
    output [31:0] D,
    output reg q,
    output reg Cout
);// 32-bit adder
    wire [31:0] sum = A + B;

    // D flip-flop
    reg d_latch;
    always @(posedge clk) begin
        if (reset) begin
            d_latch <= 0;
            q <= 0;
        end else begin
            d_latch <= d;
            q <= d_latch;
        end
    end

    // Output difference module
    assign D = sum - {31'b0, q}; // Extend q to match the width of sum

    // Carry out
    assign Cout = sum[31] & q; // Use q directly since it's 1 bit

endmodule