module top_module(input signed [31:0] input_val, output signed [31:0] output_val);// Define local parameter
   localparam constant_val = 10;
   
   // Add input_val and constant_val and store in output_val
   assign output_val = input_val + constant_val;

endmodule