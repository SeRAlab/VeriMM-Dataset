module zzadd18 ( rs1_data, rs2_data, cin, adder_out, cout );
  input  [17:0] rs1_data;   
  input  [17:0] rs2_data;   
  input         cin;        
  output [17:0] adder_out;  
  output 	cout;       
  assign {cout, adder_out} = rs1_data + rs2_data + cin;
endmodule