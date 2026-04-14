module top_module(addr, dout);input [1:6] addr;
output [1:4] dout;
reg [1:4] dout;

always @(addr) begin
    case (addr)
        6'b000000: dout = 4'b0100;
        6'b000001: dout = 4'b1010;
        6'b000010: dout = 4'b1001;
        6'b000011: dout = 4'b0010;
        6'b000100: dout = 4'b1101;
        6'b000101: dout = 4'b1000;
        6'b000110: dout = 4'b0000;
        6'b000111: dout = 4'b1110;
        6'b001000: dout = 4'b0110;
        6'b001001: dout = 4'b1011;
        6'b001010: dout = 4'b0001;
        6'b001011: dout = 4'b1100;
        6'b001100: dout = 4'b0111;
        6'b001101: dout = 4'b1111;
        6'b001110: dout = 4'b0101;
        6'b001111: dout = 4'b0011;
        default: dout = 4'b0000;
    endcase
end

endmodule