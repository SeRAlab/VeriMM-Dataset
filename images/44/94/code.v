module top_module(
  input in1,
  input in2,
  input select,
  output reg out
);always @ (select) begin
    if (select == 0) begin
      out <= in1;
    end else begin
      out <= in2;
    end
  end

endmodule