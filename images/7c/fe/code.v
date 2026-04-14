module up_down_counter(CLK, RST, DIR, Count);
input CLK, RST, DIR;
output reg [7:0] Count;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Count <= 0;
    else if (DIR)
        Count <= Count + 1;
    else
        Count <= Count - 1;
end

endmodule