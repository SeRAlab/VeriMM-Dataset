module top_module( 
    input wire [3:0] in1,
    input wire [3:0] in2,
    output wire [3:0] out,
    output wire [3:0] max_out );// Adder module to calculate the sum of in1 and in2
    // The sum is stored in the variable 'sum'
    wire [3:0] sum;
    assign sum = in1 + in2;
    
    // Comparator module to calculate the maximum value between out and sum
    // The maximum value is stored in the variable 'max_value'
    wire [3:0] max_value;
    assign max_value = (out > sum) ? out : sum;
    
    // Assigning the sum to the out port
    assign out = sum;
    
    // Assigning the maximum value to the max_out port
    assign max_out = max_value;
    
endmodule