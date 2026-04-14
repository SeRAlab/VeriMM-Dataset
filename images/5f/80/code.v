module sync_counter(CLK, RST, EN, Count);
input CLK, RST, EN;
output [2:0] Count;
reg [2:0] Count;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Count <= 0;
    else if (EN) begin
        if (Count == 7)
            Count <= 0;
        else
            Count <= Count + 1;
    end
end

endmodule