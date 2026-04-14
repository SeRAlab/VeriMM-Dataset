module gray_counter(CLK, RST, Gray_out);
input CLK, RST;
output [3:0] Gray_out;
reg [3:0] Count;
reg [3:0] Gray_out;

always@(posedge CLK or posedge RST) begin
    if (RST)
        Count <= 0;
    else
        Count <= Count + 1;
end

always@(Count) begin
    Gray_out = (Count >> 1) ^ Count;
end

endmodule