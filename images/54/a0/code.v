module top_module(
  input Reset_n_i,
  input Clk_i,
  input[15:0] D1_i,
  input[15:0] D2_i,
  output reg [15:0] Q_o,
  input Enable1_i,
  input Enable2_i
);always @(negedge Reset_n_i or posedge Clk_i)
  begin
    if (!Reset_n_i)
    begin
      Q_o <= 16'd0;
    end
    else
    begin
      if (Enable1_i)
      begin
        Q_o <= D1_i;
      end
      else if (Enable2_i)
      begin
        Q_o <= D2_i;
      end
    end  
  end

endmodule