module top_module(
    input [7:0] in,
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel,
    output [3:0] out
);// Reverse the input binary number
    wire [7:0] reversed_in;
    assign reversed_in = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
    
    // Select one of the four 4-bit inputs using the 4-to-1 multiplexer
    wire [3:0] selected_input;
    assign selected_input = (sel == 2'b00) ? in0 :
                            (sel == 2'b01) ? in1 :
                            (sel == 2'b10) ? in2 :
                                             in3;
    
    // Perform bitwise AND of the reversed binary number and the selected input
    wire [3:0] and_output;
    assign and_output = reversed_in[7:4] & selected_input;
    
    // Output the result of the AND operation
    assign out = and_output;
    
endmodule