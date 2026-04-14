module sequence_detector (
  input in, 
  input [3:0] state, 
  output reg [3:0] next_state, 
  output reg out);parameter S0=0, S1=1, S2=2, S3=3;

    assign next_state[S0] = (state[S0] & ~in) | (state[S2] & ~in) | (state[S3] & ~in);
    assign next_state[S1] = (state[S0] & in);
    assign next_state[S2] = (state[S1] & in);
    assign next_state[S3] = (state[S2] & ~in);

    assign out = state[S3] & in;
    
endmodule