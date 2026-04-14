module top_module( 
    input [3:0] in0, 
    input [3:0] in1, 
    input sel,
    input ctrl,
    output [3:0] out );wire [3:0] sum;
    wire [3:0] diff;
    
    // Calculate sum and difference
    assign sum = in0 + in1;
    assign diff = in0 - in1;
    
    // Create 2-to-1 multiplexer to select between input values
    wire [3:0] selected_input;
    assign selected_input = ctrl ? in1 : in0;
    
    // Create 4-to-1 multiplexer to select between sum and difference
    wire [3:0] selected_output;
    assign selected_output = sel ? diff : sum;
    
    // Output selected value
    assign out = selected_output;
    
endmodule