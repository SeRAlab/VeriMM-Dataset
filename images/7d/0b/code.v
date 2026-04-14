module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] diff
);always @(*) begin
        if (a >= b) begin
            diff = a - b;
        end else begin
            diff = ~(b - a) + 1;
        end
    end

endmodule