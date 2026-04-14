module binary_counter(CLK, RST, COUNT);
input CLK, RST;
output reg [3:0] COUNT;

always @(posedge CLK or negedge RST) begin
    if (!RST)
        COUNT <= 4'b0000;
    else
        COUNT <= COUNT + 1;
end

endmodule