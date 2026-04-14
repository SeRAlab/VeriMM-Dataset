module binary_counter(CLK, CLR, EN, COUNT);
input CLK, CLR, EN;
output reg [2:0] COUNT;

always @(posedge CLK or posedge CLR) begin
    if (CLR)
        COUNT <= 3'b000;
    else if (EN)
        COUNT <= COUNT + 1;
end

endmodule