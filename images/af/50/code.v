module shift_register(
    input clk,
    input load,
    input shift_enable,
    input [31:0] data,
    output reg [31:0] q);always @(posedge clk) begin
    if (load)
        q <= data;
    else if (shift_enable)
        q <= {1'b0, q[31:1]};
end
endmodule