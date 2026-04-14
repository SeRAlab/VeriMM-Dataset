module shift_register(CLK, RST, LOAD, D, Q);
input CLK, RST, LOAD;
input [7:0] D;
output reg [7:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 8'b00000000;
    else if (LOAD)
        Q <= D;
    else
        Q <= Q << 1;
end

endmodule