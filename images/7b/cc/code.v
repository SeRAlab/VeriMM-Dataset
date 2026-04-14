module counter_16bit(CLK, RST, EN, COUNT);
input CLK, RST, EN;
output reg [15:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 16'b0000000000000000;
    else if (EN)
        COUNT <= COUNT + 1;
end

endmodule