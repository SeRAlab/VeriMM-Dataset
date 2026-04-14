module register_16bit (
    input clk,
    input reset,
    input en,
    output reg [15:0] q);
always @(posedge clk) begin
    if (reset)
        q <= 16'hFFFF;
    else if (en)
        q <= q;
end
endmodule