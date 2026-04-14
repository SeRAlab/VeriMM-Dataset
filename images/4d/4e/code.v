module top_module(
    input a,
    input b,
    input c,
    input d,
    input e,
    output reg out
);reg [4:0] count;

always @(*) begin
    count = {a, b, c, d, e};
    out = (count % 2 == 1) ? 1 : 0;
end

endmodule