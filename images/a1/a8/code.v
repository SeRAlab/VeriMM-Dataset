module counter_4bit (CLK, RST, EN, Q);
input CLK, RST, EN;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 0;
    else if (EN)
        Q <= Q + 1;
end

endmodule