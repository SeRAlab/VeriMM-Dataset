module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg y
);always @(*) begin
        if ((a & b) | (a & c & d) | (b & c & d)) begin
            y <= 1;
        end else if ((a == 0) & (b == 0) & (c == 0) & (d == 0)) begin
            y <= 0;
        end
    end

endmodule