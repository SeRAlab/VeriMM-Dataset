module counter(CLK, RST, EN, COUNT);
input CLK, RST, EN;
output [3:0] COUNT;
reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 0;
    else if (EN)
        COUNT <= COUNT + 1;
end

endmodule