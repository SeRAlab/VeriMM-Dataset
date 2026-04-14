module shift_register_12bit (reg_out, clk, reset, en, serial_in);
   input clk, reset, en, serial_in;
   output [11:0] reg_out;
   
   reg [11:0] reg_out;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         reg_out <= 12'b0;
      else if (en)
         reg_out <= {reg_out[10:0], serial_in};
   end
   
endmodule