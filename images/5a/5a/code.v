module d_flipflop(clk, rst, D, Q);
input clk, rst, D;
output Q;
reg Q;

always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule