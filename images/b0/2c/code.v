module top_module(
  input CLK,
  input EN,
  output reg CLK_G
);always @(posedge CLK) begin
    if (EN) begin
      CLK_G <= CLK;
    end
    else begin
      CLK_G <= 1'b0;
    end
  end

endmodule