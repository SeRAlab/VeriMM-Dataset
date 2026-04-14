module mod10_counter(CLK, RST, Count);
input CLK, RST;
output [3:0] Count;
reg [3:0] Count;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Count <= 0;
    else if (Count == 9)
        Count <= 0;
    else
        Count <= Count + 1;
end

endmodule