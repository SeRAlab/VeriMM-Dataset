module top_module(
  input signed [lpm_width-1:0] data,
  output reg signed [lpm_width-1:0] result,
  output reg overflow
);parameter lpm_width = 1;
  parameter lpm_type = "lpm_abs";

  always @(*) begin
    if (data[lpm_width-1] == 1) begin
      result = ~data + 1;
      if (data == -((1 << (lpm_width-1)))) begin
        overflow = 1;
      end else begin
        overflow = 0;
      end
    end else begin
      result = data;
      overflow = 0;
    end
  end

  initial begin
    if (lpm_width <= 0) begin
      $display("Value of lpm_width parameter must be greater than 0(ERROR)");
      $display("Time: %0t  Instance: %m", $time);
      $finish;
    end
  end

endmodule