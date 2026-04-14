module top_module(
  input in,
  input VTHplus,
  input VTHminus,
  output out
);reg out_reg;
  reg prev_out_reg;
  
  always @ (in or VTHplus or VTHminus or prev_out_reg) begin
    if (in > VTHplus) begin
      out_reg <= 1;
    end else if (in < VTHminus) begin
      out_reg <= 0;
    end else begin
      out_reg <= prev_out_reg;
    end
  end
  
  assign out = out_reg;
  
endmodule