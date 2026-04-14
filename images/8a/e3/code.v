module up_down_counter(CLK,RST,UP,Q);
input CLK,RST,UP;
output [2:0] Q;
reg [2:0] Q;

always@(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 0;
    else if (UP)
        Q <= Q + 1;
    else
        Q <= Q - 1;
end

endmodule