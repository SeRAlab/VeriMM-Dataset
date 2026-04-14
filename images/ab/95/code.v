module top_module(
  input clk,
  input rst,
  input set,
  input j,
  input k,
  output reg q,
  output reg qbar
);always @(posedge clk, posedge rst)
    if (rst)
      begin
        q <= 1'b0;
        qbar <= 1'b1;
      end
    else
      begin
        if (set)
          begin
            q <= 1'b1;
            qbar <= 1'b0;
          end
        else if (j && k)
          begin
            q <= ~q;
            qbar <= ~qbar;
          end
        else if (j)
          begin
            q <= 1'b1;
            qbar <= 1'b0;
          end
        else if (k)
          begin
            q <= 1'b0;
            qbar <= 1'b1;
          end
      end

endmodule