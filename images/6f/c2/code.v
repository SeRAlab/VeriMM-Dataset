module top_module(
    input [3:0] binary_input,
    output [6:0] seven_segment_output
);assign seven_segment_output[6] = (binary_input == 4'b0000 || binary_input == 4'b0001 || binary_input == 4'b0111 || binary_input == 4'b1111) ? 1 : 0; //segment A
assign seven_segment_output[5] = (binary_input == 4'b0010 || binary_input == 4'b0011 || binary_input == 4'b0110 || binary_input == 4'b0111) ? 1 : 0; //segment B
assign seven_segment_output[4] = (binary_input == 4'b0001 || binary_input == 4'b0010 || binary_input == 4'b0100 || binary_input == 4'b0101 || binary_input == 4'b0110 || binary_input == 4'b1000 || binary_input == 4'b1011 || binary_input == 4'b1111) ? 1 : 0; //segment C
assign seven_segment_output[3] = (binary_input == 4'b0000 || binary_input == 4'b0001 || binary_input == 4'b0011 || binary_input == 4'b0100 || binary_input == 4'b0101 || binary_input == 4'b0111 || binary_input == 4'b1000 || binary_input == 4'b1010 || binary_input == 4'b1011 || binary_input == 4'b1111) ? 1 : 0; //segment D
assign seven_segment_output[2] = (binary_input == 4'b0001 || binary_input == 4'b0010 || binary_input == 4'b0100 || binary_input == 4'b0101 || binary_input == 4'b1000 || binary_input == 4'b1010 || binary_input == 4'b1011 || binary_input == 4'b1111) ? 1 : 0; //segment E
assign seven_segment_output[1] = (binary_input == 4'b0001 || binary_input == 4'b0000 || binary_input == 4'b0010 || binary_input == 4'b0100 || binary_input == 4'b0101 || binary_input == 4'b0111 || binary_input == 4'b1000 || binary_input == 4'b1011 || binary_input == 4'b1111) ? 1 : 0; //segment F
assign seven_segment_output[0] = (binary_input == 4'b0001 || binary_input == 4'b0000 || binary_input == 4'b0010 || binary_input == 4'b0100 || binary_input == 4'b1000 || binary_input == 4'b1010 || binary_input == 4'b1011 || binary_input == 4'b1111) ? 1 : 0; //segment G

endmodule