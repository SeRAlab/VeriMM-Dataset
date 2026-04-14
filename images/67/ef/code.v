module up_down_counter_4bit (CLK, RESET, UP_DOWN, COUNT);
input CLK;
input RESET;
input UP_DOWN;
output reg [3:0] COUNT;

always @(posedge CLK) begin
    if (RESET) begin
        COUNT <= 4'b0000;
    end
    else if (UP_DOWN) begin
        COUNT <= COUNT + 1;
    end
    else begin
        COUNT <= COUNT - 1;
    end
end

endmodule