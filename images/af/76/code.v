module top_module(clk, rstn, d, q, qn);input clk;
  input rstn;
  input d;
  output q;
  output qn;

  reg q;
  reg qn;

  always @(posedge clk) begin
    if (!rstn) begin
      q <= 1'b0;
      qn <= 1'b1;
    end else begin
      q <= d;
      qn <= ~d;
    end
  end

endmodule