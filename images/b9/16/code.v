module top_module(I, S, O);input [11:0] I;      // Corrected the input declaration
  input [3:0] S;       // Corrected the input declaration
  output O;            // Output declaration remains unchanged
  
  wire [11:0] selected_input;
  
  // Corrected the way selected_input is assigned by using the correct indexing
  assign selected_input = {I[11-S[3:3]], I[10-S[3:3]], I[9-S[3:3]], I[8-S[3:3]], I[7-S[3:3]], 
                           I[6-S[3:3]], I[5-S[3:3]], I[4-S[3:3]], I[3-S[3:3]], I[2-S[3:3]], 
                           I[1-S[3:3]], I[0-S[3:3]]}; // Adjusted to use S correctly
  
  assign O = selected_input[0];
endmodule