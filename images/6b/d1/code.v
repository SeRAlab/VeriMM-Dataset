module jkff (
    input clk,
    input resetn,
    input j,
    input k,
    output reg q);always @(posedge clk or negedge resetn) begin
    if (~resetn)
        q <= 0;
    else if (j & ~k)
        q <= 1;
    else if (~j & k)
        q <= 0;
    else if (j & k)
        q <= ~q;
end
endmodule