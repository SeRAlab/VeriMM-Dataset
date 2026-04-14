module reg_8bit (CLK, RST, EN, D, Q);
input CLK, RST, EN;
input [7:0] D;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 8'b00000000;
    end else if (EN) begin
        Q <= D;
    end
end

endmodule