module top_module(
    input [3:0] a,
    input [3:0] b,
    input c,
    input d,
    input e,
    output reg f
);always @(*) begin
        if (c == 1) begin
            f = 1;
        end else if (d == 1) begin
            f = 0;
        end else if (e == 1) begin
            f = 1;
        end else begin
            f = a + b;
        end
    end

endmodule