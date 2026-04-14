module binary_or_gate (
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] out);always @(*) begin
        out = a | b;
    end

endmodule