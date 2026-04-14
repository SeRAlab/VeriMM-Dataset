module top_module(
  input wire clk,
  input wire rst,
  input wire dir,
  output reg [7:0] count
);always @(posedge clk) begin
    if (rst) begin
      count <= 8'd0;
    end else if (dir) begin
      if (count == 8'hFF) begin
        count <= 8'h0;
      end else begin
        count <= count + 1;
      end
    end else begin
      if (count == 8'h0) begin
        count <= 8'hFF;
      end else begin
        count <= count - 1;
      end
    end
  end

endmodule