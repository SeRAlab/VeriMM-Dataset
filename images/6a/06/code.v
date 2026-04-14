module shift_register(
    input clk,
    input rst_n,
    input shift_en,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!rst_n)
        q <= 16'd0;
    else if (shift_en)
        q <= q << 1;
end

endmodule