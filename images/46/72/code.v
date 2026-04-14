module counter_down(CLK, RST, EN, COUNT);
input CLK, RST, EN;
output reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 4'b1111;
    else if (EN)
        COUNT <= COUNT - 1;
end

endmodule