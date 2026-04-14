module top_module(
  
  
  
  input  wire       z,
  output wire       n,
  output wire [2:0] irc,
  
  
  
  output reg        cond
);always @(*)
  begin: p_br_cond

    case (irc)
      3'b000:
        
        cond = 1'b1;
      3'b001:
        
        cond = z;
      3'b010:
        
        cond = n;
      3'b011:
        
        cond = n | z;
      3'b100:
        
        cond = 1'b0;
      3'b101:
        
        cond = ~z;
      3'b110:
        
        cond = ~n;
      3'b111:
        
        cond = ~(n | z);
    endcase

  end

endmodule