module top_module(
  input rst,
  input cond,
  output reg rel
);always @ (rst, cond) begin
    if (rst) begin
      rel <= 0;
    end else if (cond) begin
      rel <= 1;
    end
  end

endmodule