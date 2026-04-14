module top_module(dataa,datab,result) ;input [23:0] dataa; 
  input [23:0] datab; 
  output [47:0] result; 
  wire [23:0] dataa_wire; 
  wire [23:0] datab_wire; 
  wire [47:0] result_wire; 
  assign dataa_wire = dataa; 
  assign datab_wire = datab; 
  assign result_wire = dataa_wire * datab_wire; 
  assign result = ({result_wire[47:0]}); 
 endmodule