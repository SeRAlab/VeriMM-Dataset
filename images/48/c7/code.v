module top_module(o1, o2);parameter [31:0] ThisIsAnExtremelyLongParameterNameToTriggerTheSHA1Checksum1 = 10;
   parameter [31:0] ThisIsAnExtremelyLongParameterNameToTriggerTheSHA1Checksum2 = 20;
   output wire [31:0] o1, o2;
   assign module_scope_ExampleLong.o1 = module_scope_ExampleLong.ThisIsAnExtremelyLongParameterNameToTriggerTheSHA1Checksum1;
   assign module_scope_ExampleLong.o2 = module_scope_ExampleLong.ThisIsAnExtremelyLongParameterNameToTriggerTheSHA1Checksum2;
endmodule