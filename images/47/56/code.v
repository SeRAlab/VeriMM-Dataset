module counter_up_down(CLK, RST, DIR, COUNT);
input CLK, RST, DIR;
output reg [7:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 8'b00000000;
    else if (DIR)
        COUNT <= COUNT + 1;
    else
        COUNT <= COUNT - 1;
end

endmodule