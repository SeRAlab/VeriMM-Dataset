module up_down_counter(CLK, RST, EN, UP_DOWN, COUNT);
input CLK, RST, EN, UP_DOWN;
output [2:0] COUNT;
reg [2:0] COUNT;

always @(posedge CLK) begin
    if (RST)
        COUNT <= 3'b000;
    else if (EN) begin
        if (UP_DOWN)
            COUNT <= COUNT + 1;
        else
            COUNT <= COUNT - 1;
    end
end

endmodule