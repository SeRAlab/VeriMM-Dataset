module top_module(
  input clk,
  input rst,
  input en,
  output reg [3:0] count,
  output reg dir
);always @(posedge clk or negedge rst) begin
    if (!rst) begin
      count <= 4'b0000;
      dir <= 1'b1;
    end
    else if (en) begin
      if (dir) begin
        if (count == 4'b1111) begin
          count <= 4'b0000;
        end
        else begin
          count <= count + 1;
        end
      end
      else begin
        if (count == 4'b0000) begin
          count <= 4'b1111;
        end
        else begin
          count <= count - 1;
        end
      end
      dir <= ~dir;
    end
  end

endmodule