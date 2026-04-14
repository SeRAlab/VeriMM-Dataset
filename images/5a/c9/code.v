module up_down_counter(CLK, RST, MODE, Count);
input CLK, RST, MODE;
output [3:0] Count;
reg [3:0] Count;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Count <= 0;
    else if (MODE) begin
        if (Count == 15)
            Count <= 0;
        else
            Count <= Count + 1;
    end else begin
        if (Count == 0)
            Count <= 15;
        else
            Count <= Count - 1;
    end
end

endmodule