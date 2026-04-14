module top_module(
    input [2:0] state,
    input reset,
    output reg [7:0] display
);always @ (state)
   begin
      case({state, reset})
         {3'b000, 1'b1}: display = 8'b11_00_00_00; 
		 {3'b001, 1'b1}: display = 8'b11_00_00_00; 
		 {3'b010, 1'b1}: display = 8'b11_00_00_00; 
		 {3'b011, 1'b1}: display = 8'b11_00_00_00; 
         {3'b000, 1'b0}: display = 8'b11_11_10_01; 
         {3'b001, 1'b0}: display = 8'b10_10_01_00; 
         {3'b010, 1'b0}: display = 8'b10_11_00_00; 
         {3'b011, 1'b0}: display = 8'b10_01_10_01; 
         default: display = 8'b11_11_11_11; 
      endcase
   end
endmodule