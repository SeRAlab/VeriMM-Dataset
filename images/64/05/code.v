module shift_register(CLK, RST, D, Q);
input CLK, RST, D;
output [7:0] Q;
reg [7:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 0;
    else
        Q <= {Q[6:0], D};
end

endmodule