module top_module(
    input a, 
    input b,
    input c, 
    output reg out
);always @(*) begin
        out = (a & b & c) ? 1 : ((a & b) ? ((c) ? 3 : 2) : ((b & c) ? ((a) ? 3 : 2) : ((a & c) ? ((b) ? 3 : 2) : ((a) ? 2 : 1))));
    end

endmodule