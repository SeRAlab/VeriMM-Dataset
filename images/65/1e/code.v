module shift_reg_16bit(
    input clk,
    input rst,
    input en,
    input d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 16'b0;
    else if (en)
        q <= {q[14:0], d};
end

endmodule