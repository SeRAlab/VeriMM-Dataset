module binary_counter(CLK, RST, EN, COUNT);
input CLK, RST, EN;
output reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 4'b0000;
    else if (EN)
        COUNT <= COUNT + 1;
end

endmodule