module binary_counter(CLK, RST, COUNT);
input CLK, RST;
output [3:0] COUNT;
reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        COUNT <= 0;
    else if (COUNT == 4'b1111)
        COUNT <= 0;
    else
        COUNT <= COUNT + 1;
end

endmodule