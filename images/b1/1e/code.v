module top_module(
  input wire clk,
  input wire rst,
  input wire en,
  input wire up,
  input wire [31:0] width,
  output reg [31:0] count
);always @(posedge clk) begin
    if (rst) begin
      count <= 0;
    end else if (en) begin
      if (up) begin
        if (count == (2**width - 1)) begin
          count <= 0;
        end else begin
          count <= count + 1;
        end
      end else begin
        if (count == 0) begin
          count <= (2**width - 1);
        end else begin
          count <= count - 1;
        end
      end
    end
  end

endmodule