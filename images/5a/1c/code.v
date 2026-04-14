module register_8bit(D, CLK, RESET, Q);
input [7:0] D;
input CLK, RESET;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (RESET)
        Q <= 8'b0;
    else
        Q <= D;
end

endmodule