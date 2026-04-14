module counter_3bit_updown(CLK, RESET, UP_DOWN, COUNT);
input CLK, RESET, UP_DOWN;
output reg [2:0] COUNT;

always @(posedge CLK or posedge RESET) begin
    if (RESET)
        COUNT <= 3'b000;
    else if (UP_DOWN)
        COUNT <= COUNT + 1;
    else
        COUNT <= COUNT - 1;
end

endmodule