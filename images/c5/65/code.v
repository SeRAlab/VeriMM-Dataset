module counter(
  input clk,
  input rst,
  input up_down,
  output reg [7:0] out
);

  always @(posedge clk) begin
    if (rst) begin
      out <= 8'd0;
    end else begin
      if (up_down) begin
        if (out == 8'd255) begin
          out <= 8'd0;
        end else begin
          out <= out + 1;
        end
      end else begin
        if (out == 8'd0) begin
          out <= 8'd255;
        end else begin
          out <= out - 1;
        end
      end
    end
  end

endmodule