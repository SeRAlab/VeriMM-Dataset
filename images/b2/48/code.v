module top_module(clk, reset_n, test_expr, xzcheck_enable, parity_result);parameter width = 1;
  input clk, reset_n;
  input [width-1:0] test_expr;
  input xzcheck_enable;
  output reg parity_result;
  
  reg [width-1:0] data;
  reg parity;
  
  always @ (posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data <= 0;
      parity <= 1;
      parity_result <= 0;
    end else begin
      if (xzcheck_enable && (test_expr === 1'bx || test_expr === 1'bz)) begin
        $display("Error: Input data contains X or Z values");
      end else begin
        data <= test_expr;
        parity <= ^data;
        parity_result <= ~parity;
      end
    end
  end
endmodule