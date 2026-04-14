module binary_subtractor (
    input [1:0] a,
    input [1:0] b,
    output reg [1:0] out);always @(*) begin
        out = a - b;
    end

endmodule