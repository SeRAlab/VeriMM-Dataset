module counter4 (
    input clk,
    input resetn,
    output reg [3:0] q);always @(posedge clk or negedge resetn) begin
    if (~resetn)
        q <= 4'b0000;
    else
        q <= q + 1;
end
endmodule