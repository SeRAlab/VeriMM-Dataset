module up_down_counter(CLK, RST, UpDown, Count);
input CLK, RST, UpDown;
output [2:0] Count;
reg [2:0] Count;

always@(posedge CLK or posedge RST) begin
    if (RST)
        Count <= 0;
    else if (UpDown)
        Count <= Count + 1;
    else
        Count <= Count - 1;
end

endmodule