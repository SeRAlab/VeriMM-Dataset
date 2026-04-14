module zzadd32 ( rs1_data, rs2_data, cin, adder_out, cout );
  input  [31:0] rs1_data;   
  input  [31:0] rs2_data;   
  input         cin;        
  output [31:0] adder_out;  
  output 	cout;       
  assign {cout, adder_out} = rs1_data + rs2_data + cin;
endmodule