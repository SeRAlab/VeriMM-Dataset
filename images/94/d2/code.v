module up_down_counter(CLK, RST, ctrl, count);
input CLK, RST, ctrl;
output [7:0] count;
reg [7:0] count;

always@(posedge CLK or posedge RST) begin
    if (RST)
        count <= 0;
    else if (ctrl)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule