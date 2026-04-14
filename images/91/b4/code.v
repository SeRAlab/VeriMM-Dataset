module up_down_counter_3bit(CLK, RESET, UP, DOWN, COUNT);
input CLK;
input RESET;
input UP;
input DOWN;
output reg [2:0] COUNT;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        COUNT <= 3'b000;
    end else if (UP) begin
        COUNT <= COUNT + 1;
    end else if (DOWN) begin
        COUNT <= COUNT - 1;
    end
end

endmodule