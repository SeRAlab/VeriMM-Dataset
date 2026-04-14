module top_module(
    input [3:0] binary_in, // 4-bit binary input for binary-to-Gray code converter module
    input [3:0] comp_in_1, // 4-bit input 1 for comparator module
    input [3:0] comp_in_2, // 4-bit input 2 for comparator module
    output [3:0] gray_out, // 4-bit Gray code output from binary-to-Gray code converter module
    output comp_out, // 1-bit output from comparator module
    output [3:0] shift_out // 4-bit output from functional module
);// Binary-to-Gray code converter module
// Each bit of the binary input is XOR-ed with the previous bit to generate the corresponding bit of the Gray code output
assign gray_out[0] = binary_in[0];
assign gray_out[1] = binary_in[0] ^ binary_in[1];
assign gray_out[2] = binary_in[1] ^ binary_in[2];
assign gray_out[3] = binary_in[2] ^ binary_in[3];

// 4-bit comparator module
// The two inputs are compared bit by bit, starting with the most significant bit
// If the two bits being compared are equal, the next pair of bits should be compared
// If they are not equal, a 1 should be output if the first input is greater than the second input, and a 0 should be output otherwise
assign comp_out = (comp_in_1[3] == comp_in_2[3]) ? 
                    ((comp_in_1[2] == comp_in_2[2]) ? 
                        ((comp_in_1[1] == comp_in_2[1]) ? 
                            (comp_in_1[0] >= comp_in_2[0]) : 
                        (comp_in_1[1] > comp_in_2[1])) : 
                    (comp_in_1[2] > comp_in_2[2])) : 
                (comp_in_1[3] > comp_in_2[3]);

// Functional module
// If the comparator result is 1, indicating that the first input is greater than or equal to the second input, the Gray code output should be shifted left by one bit
// If the comparator result is 0, indicating that the first input is less than the second input, the Gray code output should be shifted right by one bit
assign shift_out = (comp_out == 1) ? (gray_out << 1) : (gray_out >> 1);

endmodule