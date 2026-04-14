module reg_8bit (CLK, LD, D, Q);
input CLK, LD;
input [7:0] D;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (LD)
        Q <= D;
end

endmodule