module binary_aoi (
    input [3:0] a,
    input [3:0] b,
    output reg out);always @(*) begin
        out = ~((a & b) | (a | b));
    end

endmodule