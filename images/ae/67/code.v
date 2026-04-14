module top_module(i1, i0, s, z);(* src = "../lib/mux_2to1.v:2" *) 
  input i1; 
  (* src = "../lib/mux_2to1.v:2" *) 
  input i0; 
  (* src = "../lib/mux_2to1.v:2" *) 
  input s; 
  (* src = "../lib/mux_2to1.v:3" *) 
  output z; 
  (* src = "../lib/mux_2to1.v:5" *) 
  wire int0; 
  (* src = "../lib/mux_2to1.v:5" *) 
  wire int1; 
  (* src = "../lib/mux_2to1.v:5" *) 
  wire s_bar; 
  assign z = int0 | int1; 
  assign int1 = i1 & s; 
  assign int0 = i0 & s_bar; 
  assign s_bar = ~s; 
 endmodule