module top_module(input logic [8*16-1:0] wide_input_bus,
   input logic [3:0] selector,
   output logic [7:0] selected_out);always_comb begin
      selected_out = 8'b0; // Default output
      selected_out = wide_input_bus[selector * 8 +: 8]; // Selects the appropriate 8-bit slice
   end

endmodule