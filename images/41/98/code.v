module binary_subtractor (
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] diff);always @(*) begin
        diff = a - b;
    end

endmodule