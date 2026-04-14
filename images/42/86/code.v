module top_module(
    input [7:0] a,
    input [7:0] b,
    input reset,
    output reg [15:0] out
);always @(*) begin
        if (reset == 0) begin
            out <= 0;
        end
        else begin
            out <= a * b;
        end
    end

endmodule