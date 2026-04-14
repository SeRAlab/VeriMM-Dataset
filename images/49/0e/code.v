module top_module(
  input         rst,
  input         in_en,

  input         out_clk,
  output  reg   out_en

);reg       [2:0]  out_en_sync;



always @ (posedge out_clk) begin
  if (rst) begin
    out_en_sync   <=  0;
    out_en        <=  0;
  end
  else begin
    if (out_en_sync[2:1] == 2'b11) begin
      out_en      <=  1;
    end
    else if (out_en_sync[2:1] == 2'b00) begin
      out_en      <=  0;
    end
    out_en_sync   <=  {out_en_sync[1:0], in_en};
  end
end
endmodule