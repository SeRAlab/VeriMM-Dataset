module top_module(
    input [7:0] in1,
    input [7:0] in2,
    output reg [7:0] out
);// Step 1: Compute the bitwise AND of in1 and in2
    wire [7:0] and_result = in1 & in2;
    
    // Step 2: Compute the bitwise OR of in1 and in2
    wire [7:0] or_result = in1 | in2;
    
    // Step 3: Add the results of step 1 and step 2
    wire [8:0] add_result = and_result + or_result;
    
    // Step 4: Compute the bitwise XOR of the results of step 1 and step 2
    wire [7:0] xor_result = and_result ^ or_result;
    
    // Step 5: Add 1 to the result of step 4
    wire [7:0] add_one = 1;
    wire [7:0] add_one_result = xor_result + add_one;
    
    // Step 6: Assign the result of step 5 to out
    always @(*) begin
        out = add_one_result;
    end
    
endmodule