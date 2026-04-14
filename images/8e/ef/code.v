module top_module(packet, data, data_error);(* src = "data_setup.v:12" *) 
  output [63:0] data; 
  (* src = "data_setup.v:13" *) 
  output data_error; 
  (* src = "data_setup.v:11" *) 
  input [88:0] packet; 
  assign data = packet[79:16]; 
  assign data_error = 1'b1; 
 endmodule