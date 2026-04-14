module top_module(
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    input [WIDTH-1:0] in3,
    input sel0,
    input sel1,
    output reg [WIDTH-1:0] out
);parameter WIDTH = 1;

always @(*) begin
    case ({sel1, sel0})
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
    endcase
end

endmodule