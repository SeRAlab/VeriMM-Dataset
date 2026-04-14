module register_8bit(D, CLK, EN, Q);
input [7:0] D;
input CLK, EN;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (EN)
        Q <= D;
end
endmodule