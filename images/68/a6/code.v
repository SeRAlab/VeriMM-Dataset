module piso_shift_register_8bit (dout, din, clk, reset, load);
   input [7:0] din;
   input clk, reset, load;
   output dout;
   
   reg [7:0] shift_reg;
   reg dout;
   
   always @(posedge clk or posedge reset) begin
      if (reset) 
         shift_reg <= 8'b0;
      else if (load)
         shift_reg <= din;
      else 
         shift_reg <= {shift_reg[6:0], 1'b0};
   end
   
   always @(posedge clk or posedge reset) begin
      if (reset) 
         dout <= 1'b0;
      else 
         dout <= shift_reg[7];
   end
   
endmodule