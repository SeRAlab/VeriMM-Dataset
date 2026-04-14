module top_module(input [3:0] num,input en,output reg [6:0] seg);always @(num or en) 
  if (!en) seg <= 7'h3f; 
  else 
  case (num) 
  4'h0: seg <= {1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; 
  4'h1: seg <= {1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1}; 
  4'h2: seg <= {1'b0,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0}; 
  4'h3: seg <= {1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0}; 
  4'h4: seg <= {1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1}; 
  4'h5: seg <= {1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,1'b0}; 
  4'h6: seg <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0}; 
  4'h7: seg <= {1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0}; 
  4'h8: seg <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}; 
  4'h9: seg <= {1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0}; 
  4'ha: seg <= {1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0}; 
  4'hb: seg <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}; 
  4'hc: seg <= {1'b0,1'b1,1'b0,1'b0,1'b1,1'b1,1'b1}; 
  4'hd: seg <= {1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1}; 
  4'he: seg <= {1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0}; 
  4'hf: seg <= {1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0}; 
  endcase 
 endmodule