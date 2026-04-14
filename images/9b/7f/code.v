module top_module(
  input ctrl,
  input D0,
  input D1,
  output reg S
);always @(*) begin
    if (ctrl == 0) begin
      S = D0;
    end else begin
      S = D1;
    end
  end

endmodule