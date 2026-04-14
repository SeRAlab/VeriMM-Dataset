module up_down_counter(CLK, RST, UP, DOWN, Q);
input CLK, RST, UP, DOWN;
output reg [2:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 3'b000;
    else if (UP && !DOWN)
        Q <= Q + 1'b1;
    else if (!UP && DOWN)
        Q <= Q - 1'b1;
end

endmodule