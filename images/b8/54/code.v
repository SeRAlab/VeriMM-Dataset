module top_module(
  input reset_n,
  input test_expr,
  input xzdetect_bit,
  input xzcheck_enable,
  output reg pass,
  output reg [1:0] fail_reason
);always @(posedge reset_n) begin
    if (!reset_n) begin
      pass <= 0;
      fail_reason <= 2'b00;
    end else begin
      if (xzdetect_bit && xzcheck_enable && ($isunknown(test_expr))) begin
        pass <= 0;
        fail_reason <= 2'b01;
      end else if (!test_expr) begin
        pass <= 0;
        fail_reason <= 2'b10;
      end else begin
        pass <= 1;
        fail_reason <= 2'b00;
      end
    end
  end

endmodule