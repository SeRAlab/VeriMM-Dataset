module counter_3bit(CLK, RST, EN, COUNT);
input CLK, RST, EN;
output reg [2:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 3'b000;
    else if (EN)
        COUNT <= COUNT + 1;
end

endmodule