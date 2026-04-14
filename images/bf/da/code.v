module zzadd48 ( rs1_data, rs2_data, cin, adder_out );
  input  [47:0] rs1_data;   
  input  [47:0] rs2_data;   
  input         cin;        
  output [47:0] adder_out;  
  assign adder_out = rs1_data + rs2_data + cin;
endmodule