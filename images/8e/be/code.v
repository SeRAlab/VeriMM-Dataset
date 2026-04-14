module shift_register(CLK, RST, SHIFT_EN, Q);
input CLK, RST, SHIFT_EN;
output [3:0] Q;
reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 0;
    else if (SHIFT_EN)
        Q <= {1'b0, Q[3:1]};
end

endmodule