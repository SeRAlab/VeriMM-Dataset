module up_down_counter(CLK, RST, DIR, COUNT);
input CLK, RST, DIR;
output reg [3:0] COUNT;

always @(posedge CLK) begin
    if (RST)
        COUNT <= 4'b0000;
    else if (DIR)
        COUNT <= COUNT + 1;
    else
        COUNT <= COUNT - 1;
end

endmodule