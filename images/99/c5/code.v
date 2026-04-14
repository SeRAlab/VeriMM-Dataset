module up_down_counter(CLK, RST, UP, COUNT);
input CLK, RST, UP;
output [1:0] COUNT;
reg [1:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 2'b00;
    else if (UP)
        COUNT <= COUNT + 1;
    else
        COUNT <= COUNT - 1;
end

endmodule