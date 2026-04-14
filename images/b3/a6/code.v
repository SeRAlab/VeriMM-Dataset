module top_module (
  input in1,
  input state,
  output reg next_state,
  output reg out);parameter S1=0, S2=1;

    always_comb begin
        case (state)
            S1: next_state = in1 ? S2 : S1;
            S2: next_state = in1 ? S2 : S1;
        endcase
    end
    
    assign out = (state == S2);
    
endmodule