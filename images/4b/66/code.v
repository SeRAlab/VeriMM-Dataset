module up_down_counter(CLK, RST, UP, DOWN, COUNT);
input CLK, RST, UP, DOWN;
output [3:0] COUNT;
reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 0;
    else if (UP)
        COUNT <= COUNT + 1;
    else if (DOWN)
        COUNT <= COUNT - 1;
end

endmodule