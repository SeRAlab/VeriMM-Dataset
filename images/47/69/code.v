module top_module(
    input clk,              // Added clk input
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    output [7:0] out_xor,
    output [7:0] out_and,
    output reg [7:0] out_final
);// XOR module
    assign out_xor = in1 ^ in2;

    // AND module
    assign out_and = in1 & in2 & in3;

    // Additive functional module
    always @ (posedge clk) begin
        out_final <= out_xor + out_and;
    end

endmodule