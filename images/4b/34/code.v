module top_module (
  input in1,
  input state,
  output reg next_state,
  output reg out);parameter B1=0, B2=1;

    always_comb begin
        case (state)
            B1: next_state = in1 ? B2 : B1;
            B2: next_state = in1 ? B2 : B1;
        endcase
    end
    
    assign out = (state == B2);
    
endmodule