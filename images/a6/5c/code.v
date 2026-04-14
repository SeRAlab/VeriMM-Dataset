module counter_up_down(CLK, RST, EN, UP_DOWN, COUNT);
input CLK, RST, EN, UP_DOWN;
output reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 4'b0000;
    else if (EN) begin
        if (UP_DOWN)
            COUNT <= COUNT + 1;
        else
            COUNT <= COUNT - 1;
    end
end

endmodule