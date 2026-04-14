module counter_down_5bit(CLK, RST, EN, COUNT);
input CLK, RST, EN;
output reg [4:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 5'b11111;
    else if (EN)
        COUNT <= COUNT - 1;
end

endmodule