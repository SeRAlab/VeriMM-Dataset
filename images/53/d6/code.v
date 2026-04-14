module parallel_load_register(CLK, RST, LOAD_EN, D, Q);
input CLK, RST, LOAD_EN;
input [3:0] D;
output [3:0] Q;
reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Q <= 0;
    else if (LOAD_EN)
        Q <= D;
end

endmodule