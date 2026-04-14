module counter_up_down(CLK, RST, UP, COUNT);
input CLK, RST, UP;
output reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 4'b0000;
    else if (UP)
        COUNT <= COUNT + 1;
    else
        COUNT <= COUNT - 1;
end

endmodule