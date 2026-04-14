module shift_reg4 (
    input clk,
    input reset,
    input d,
    output reg [3:0] q);always @(posedge clk) begin
    if (reset)
        q <= 4'b0;
    else
        q <= {q[2:0], d};
end
endmodule