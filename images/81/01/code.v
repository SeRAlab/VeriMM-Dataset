module mealy_machine_4 (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out);parameter G=0, H=1, I=2, J=3;
    
    assign next_state[G] = (state[H] & ~in) | (state[J] & ~in);
    assign next_state[H] = (state[G] & ~in) | (state[I] & ~in);
    assign next_state[I] = (state[G] & in) | (state[J] & in);
    assign next_state[J] = (state[H] & in) | (state[I] & in);
    
    assign out = (state[G] & in) | (state[I]) | (state[J] & in);
    
endmodule