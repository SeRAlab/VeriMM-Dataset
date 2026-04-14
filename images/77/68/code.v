module reg_set_reset(
    input clk,
    input rst,
    input set,
    input [5:0] set_value,

    output reg [5:0] q
);

always @(posedge clk)
begin
    if (rst)
        q <= 6'b000000;         // reset
    else if (set)
        q <= set_value;         // set
end

endmodule