module register_8bit (D, CLK, RST, EN, Q);
input [7:0] D;
input CLK, RST, EN;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 8'b00000000;
    end
    else if (EN) begin
        Q <= D;
    end
end

endmodule