module top_module(
    input a,
    input b,
    input c,
    output reg out
);always @(*) begin
        if(a + b + c == 1 || a + b + c == 3) begin
            out = 1;
        end
        else begin
            out = 0;
        end
    end

endmodule