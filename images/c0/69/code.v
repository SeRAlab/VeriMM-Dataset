module zzadd32op4 ( rs1_data, rs2_data, rs3_data, rs4_data, adder_out );
  input  [31:0] rs1_data;   
  input  [31:0] rs2_data;   
  input  [31:0] rs3_data;   
  input  [31:0] rs4_data;   
  output [31:0] adder_out;  
  assign adder_out = rs1_data + rs2_data + rs3_data + rs4_data;
endmodule