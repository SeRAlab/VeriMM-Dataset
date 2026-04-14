module top_module(o1, o2);parameter [31:0] v1 = 10; 
  parameter [31:0] v2 = 20; 
  output [31:0] o1, o2; 
  assign module_scope_Example.o1 = module_scope_Example.v1; 
  assign module_scope_Example.o2 = module_scope_Example.v2; 
 endmodule