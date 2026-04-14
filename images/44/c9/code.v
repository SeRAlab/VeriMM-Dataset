module register_4bit(CLK, RST, LOAD, D, Q);
input CLK, RST, LOAD;
input [3:0] D;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 4'b0000;
    else if (LOAD)
        Q <= D;
end

endmodule