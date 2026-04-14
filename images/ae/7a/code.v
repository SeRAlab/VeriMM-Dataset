module register_with_set_reset (
    input clk,
    input set,
    input rst,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 32'b00000000000000000000000000000000;
    else if (set)
        q <= 32'b11111111111111111111111111111111;
end

endmodule