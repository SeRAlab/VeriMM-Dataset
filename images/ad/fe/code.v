module up_down_counter (
  input in,
  input state,
  output reg next_state);parameter UP=0, DOWN=1;

    always_comb begin
        case (state)
            UP: next_state = in ? UP : DOWN;
            DOWN: next_state = in ? UP : DOWN;
        endcase
    end
    
endmodule