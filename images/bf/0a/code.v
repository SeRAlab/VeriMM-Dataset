module shift_register (CLK, RST, Q);
input CLK, RST;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 4'b0000;
    else
        Q <= Q << 1;
end

endmodule