module binary_subtractor (
    input [2:0] x,
    input [2:0] y,
    output reg [2:0] diff);always @(*) begin
        diff = x - y;
    end

endmodule