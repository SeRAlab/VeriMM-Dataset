module top_module(/*AUTOARG*/
                   // Outputs
                   o_bus,
                   // Inputs
                   i_bus1,
                   i_bus2
                   );input logic [7:0]  i_bus1 ;
   input logic [7:0]  i_bus2 ;
   output logic [7:0] o_bus ;
   
   assign o_bus = i_bus1 & i_bus2;
   
endmodule