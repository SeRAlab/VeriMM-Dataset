module top_module(
    binary_in,
    binary_out
);input [3:0] binary_in;
output reg [1:0] binary_out; // Change to 'reg' since we are assigning values in an always block

always @(*) begin
    case (binary_in)
        4'b0000: binary_out = 2'b00;
        4'b0001: binary_out = 2'b01;
        4'b0010: binary_out = 2'b10;
        4'b0011: binary_out = 2'b11;
        4'b0100: binary_out = 2'b00;
        4'b0101: binary_out = 2'b01;
        4'b0110: binary_out = 2'b10;
        4'b0111: binary_out = 2'b11;
        4'b1000: binary_out = 2'b00;
        4'b1001: binary_out = 2'b01;
        4'b1010: binary_out = 2'b10;
        4'b1011: binary_out = 2'b11;
        4'b1100: binary_out = 2'b00;
        4'b1101: binary_out = 2'b01;
        4'b1110: binary_out = 2'b10;
        4'b1111: binary_out = 2'b11;
        default: binary_out = 2'b00;
    endcase
end

endmodule