module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input clk,
    output reg [3:0] S,  // Change to output reg
    output reg Cout      // Change to output reg
);always @(posedge clk) begin
        {Cout, S} <= A + B + Cin;  // Use concatenation for Cout
    end

endmodule