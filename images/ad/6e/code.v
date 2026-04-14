module register(D, CLK, LOAD, RST, Q);
input [3:0] D;
input CLK, LOAD, RST;
output reg [3:0] Q;

always@(posedge CLK or posedge RST) begin
    if(RST)
        Q <= 4'b0000;
    else if(LOAD)
        Q <= D;
end

endmodule