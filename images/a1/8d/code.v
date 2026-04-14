module top_module(
      input CLK,
      input RESET_N,
      input CLKEN,
      input TDI,
      output TDO,
      output reg [7:0] DATA_OUT,
      input DATA_IN,
      input CAPTURE_DR,
      input UPDATE_DR
   );reg [7:0] shift_reg;
  reg tdoInt;

  always @ (negedge CLK or negedge RESET_N)
  begin
      if (RESET_N == 1'b0)
         begin
            tdoInt <= #1 1'b0;
            shift_reg <= #1 8'h00;
         end
      else if (CLK == 1'b0)
         begin
            if (CLKEN == 1'b1)
               begin
                  if (CAPTURE_DR == 1'b0)
                     begin
                        shift_reg <= #1 {shift_reg[6:0], TDI};
                        tdoInt <= #1 TDI;
                     end
                  else
                     begin
                        shift_reg <= #1 {shift_reg[6:0], DATA_IN};
                        tdoInt <= #1 DATA_IN;
                     end
               end
         end
  end

   assign TDO = tdoInt;

  always @ (negedge CLK or negedge RESET_N)
   begin
      if (RESET_N == 1'b0)
         DATA_OUT <= #1 8'h00;
      else if (CLK == 1'b0)
         begin
            if (UPDATE_DR == 1'b1)
               DATA_OUT <= #1 shift_reg;
         end
   end
endmodule