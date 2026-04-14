module top_module(
        addr        ,   
        din         ,   
        dout            
        ) ;input   [4:0]   addr ;
input   [7:0]   din ;
output  [7:0]   dout ;




reg     [7:0]   scram_mask ;




assign dout = din ^ scram_mask ;

always @*
  begin
    case (addr[4:0])
      0: scram_mask = 40 ;
      1: scram_mask = 198 ;
      2: scram_mask = 78 ; 
      3: scram_mask = 63 ; 
      4: scram_mask = 82 ; 
      5: scram_mask = 173 ;
      6: scram_mask = 102 ; 
      7: scram_mask = 245 ; 
      8: scram_mask = 48 ; 
      9: scram_mask = 111 ; 
      10: scram_mask = 172 ; 
      11: scram_mask = 115 ; 
      12: scram_mask = 147 ; 
      13: scram_mask = 230 ; 
      14: scram_mask = 216 ; 
      15: scram_mask = 93 ; 
      16: scram_mask = 72 ; 
      17: scram_mask = 65 ; 
      18: scram_mask = 62 ;
      19: scram_mask = 2 ;
      20: scram_mask = 205 ; 
      21: scram_mask = 242 ;
      22: scram_mask = 122 ;
      23: scram_mask = 90 ;
      24: scram_mask = 128 ;
      25: scram_mask = 83 ;
      26: scram_mask = 105 ;
      27: scram_mask = 97 ;
      28: scram_mask = 73 ; 
      29: scram_mask = 10 ;
      30: scram_mask = 5 ;
      31: scram_mask = 252 ;
      default: scram_mask = 40 ;
    endcase
  end

endmodule