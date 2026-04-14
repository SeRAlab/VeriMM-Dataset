module top_module( input [3:0] in, output [3:0] out );// Two 2-bit adders
    wire [1:0] adder1_out;
    wire [1:0] adder2_out;
    
    // NOT gate
    wire [1:0] not_out;
    
    // Add 2 to input value
    assign adder1_out = in[1:0] + 2;
    
    // Add 1 to input value
    assign adder2_out = in[1:0] + 1;
    
    // Invert the sum of the two adders
    assign not_out = ~(adder1_out + adder2_out);
    
    // Output the result
    assign out = {not_out[1], not_out[0]};
    
endmodule