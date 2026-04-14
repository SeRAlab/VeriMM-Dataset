module binary_counter(CLK, RST, ENABLE, Q);
input CLK, RST, ENABLE;
output reg [1:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 2'b00;
    else if (ENABLE)
        Q <= Q + 1'b1;
end

endmodule