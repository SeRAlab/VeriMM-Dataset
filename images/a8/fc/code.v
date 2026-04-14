module top_module(
    input [3:0] a,
    input [3:0] b,
    input sub,
    output reg [3:0] sum
);always @(*) begin
        if(sub) begin
            sum <= a - b;
        end else begin
            sum <= a + b;
        end
    end

endmodule