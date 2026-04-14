module register_8bit_with_enable(CLK, RESET, EN, D, Q);
input CLK, RESET, EN;
input [7:0] D;
output [7:0] Q;
reg [7:0] Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET)
        Q <= 8'b00000000;
    else if (EN)
        Q <= D;
end

endmodule