module shift_register_16bit (p_out, clk, reset, en, s_in);
   input clk, reset, en, s_in;
   output [15:0] p_out;
   
   reg [15:0] p_out;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         p_out <= 16'b0;
      else if (en)
         p_out <= {p_out[14:0], s_in};
   end
   
endmodule