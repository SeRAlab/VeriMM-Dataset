module shift_register(
    input clk,
    input load,
    input shift_right,
    input [15:0] d,
    output reg [15:0] q);always @(posedge clk) begin
    if (load)
        q <= d;
    else if (shift_right)
        q <= q >> 1;
    else
        q <= q << 1;
end
endmodule