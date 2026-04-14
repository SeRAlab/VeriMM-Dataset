module register_8bit (CLK, CLR, LOAD, D, Q);
input CLK, CLR, LOAD;
input [7:0] D;
output reg [7:0] Q;

always @(posedge CLK or posedge CLR) begin
    if (CLR)
        Q <= 8'b00000000;
    else if (LOAD)
        Q <= D;
end

endmodule