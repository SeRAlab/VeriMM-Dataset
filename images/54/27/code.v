module top_module(input [15:0] a, input [4:0] o_vhdl, input [4:0] o_verilog);reg ena; 
 initial begin 
  ena = 0; 
  #10; 
  ena = 1; 
 end 
 always @(a)begin 
  #1 if (ena == 0) begin end 
  else if (o_vhdl !== o_verilog) begin 
  $display("ERROR!"); 
  $display("VERILOG: ", o_verilog); 
  $display("VHDL: ", o_vhdl); 
  end 
 end 
 endmodule