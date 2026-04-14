module top_module(input logic [1:0]  value,
            output logic [2:0] out0,
            output logic [2:0] out1);always_comb begin
    
    
    priority casez (value)
      2'b ?1: out0 = 3'd0;
      2'b 1?: out0 = 3'd1;
      default: out0 = 3'd2;
    endcase

    
    
    priority casez (value)
      2'b ?1: out1 = 3'd0;
      2'b ?1: out1 = 3'd1;
      default: out1 = 3'd2;
    endcase

    
    
    
    
    priority casez (value)
      2'b ?1: out1 = 3'd0;
      2'b ?1: out1 = 3'd1;
      2'b 11: out1 = 3'd2;
      default: out1 = 3'd3;
    endcase
  end

endmodule