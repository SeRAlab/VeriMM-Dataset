module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Clock,
    output reg [3:0] Sum,  // Change to output reg
    output reg Cout        // Change to output reg
);always @(posedge Clock) begin
    {Cout, Sum} = A + B + Cin;
end

endmodule