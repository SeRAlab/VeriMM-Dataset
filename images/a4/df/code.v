module shift_reg_4bit(
    input clk,
    input rst,
    input d,

    output reg [3:0] q
);

always @(posedge clk)
begin
    if (rst)
        q <= 4'b0000;   // reset
    else
        q <= {q[2:0], d}; // shift left and load new bit
end

endmodule