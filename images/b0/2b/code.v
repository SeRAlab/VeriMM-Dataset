module top_module(data1);(* src = "data_type.v:1" *)
  (* unused_bits = "0 1 2 3" *)
  wire [3:0] \byte1[0] ;
  (* src = "data_type.v:1" *)
  (* unused_bits = "0 1 2 3" *)
  wire [3:0] \byte1[1] ;
  (* src = "data_type.v:1" *)
  (* unused_bits = "0 1 2 3" *)
  wire [3:0] \byte1[2] ;
  (* src = "data_type.v:1" *)
  (* unused_bits = "0 1 2 3" *)
  wire [3:0] \byte1[3] ;
  (* src = "data_type.v:2" *)
  input [31:0] data1;
  (* src = "data_type.v:8" *)
  wire [31:0] j;
  assign \byte1[0]  = data1[3:0];
  assign \byte1[1]  = data1[11:8];
  assign \byte1[2]  = data1[19:16];
  assign \byte1[3]  = data1[27:24];
  assign j = 32'd4;
endmodule