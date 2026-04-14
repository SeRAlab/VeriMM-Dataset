module up_down_counter (CLK, RST, UP, Q);
input CLK, RST, UP;
output reg [2:0] Q;

always @(posedge CLK) begin
    if (RST)
        Q <= 3'b000;
    else if (UP)
        Q <= Q + 1;
    else
        Q <= Q - 1;
end

endmodule