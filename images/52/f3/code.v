module top_module(a, b, c);(* LOC = "P20 P19" *) 
  input wire[1:0] a; 
  (* LOC = "P18 P17" *) 
  input wire[1:0] b; 
  (* LOC = "P16 P15" *) 
  output wire[1:0] c; 
  assign c = a & b; 
 endmodule