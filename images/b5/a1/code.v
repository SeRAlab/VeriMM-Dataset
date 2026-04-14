module top_module(Aval, Bval, cin, op, ALUout, cout);input [7:0] Aval; 
  input [7:0] Bval; 
  input cin; 
  input [1:0] op; 
  output cout; 
  output [7:0] ALUout; 
  reg cout; 
  reg [7:0] ALUout; 
  always @(Aval or Bval or cin or op) begin 
  case(op) 
  2'b00 : {cout, ALUout} = Aval + Bval; 
  2'b10 : {cout, ALUout} = {1'b0, Aval & Bval}; 
  2'b01 : {cout, ALUout} = 9'h100 ^ (Aval + Bval + 9'h001); 
  2'b11 : {cout, ALUout} = {1'b0, 8'b1 << Bval}; 
  endcase 
  end 
 endmodule