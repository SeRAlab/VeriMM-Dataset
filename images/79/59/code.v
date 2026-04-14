module shift_reg(
    input clk,
    input rst,
    input load,
    input shift,
    input [3:0] d,
    
    output reg [3:0] q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        q <= 4'b0;
    else if (load)
        q <= d;
    else if (shift)
        q <= {1'b0, q[3:1]};
end

endmodule