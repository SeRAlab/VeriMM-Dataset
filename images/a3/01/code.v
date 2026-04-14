module up_down_counter_3bit(CLK, UP, DOWN, COUNT);
input CLK;
input UP;
input DOWN;
output reg [2:0] COUNT;

always @(posedge CLK) begin
    if (UP) begin
        COUNT <= COUNT + 1;
    end else if (DOWN) begin
        COUNT <= COUNT - 1;
    end
end

endmodule