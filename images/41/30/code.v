module top_module(
  input clk,
  input rst,
  input cnt_en,
  output reg [7:0] count
);parameter MAX_COUNT = 255;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      count <= 8'h00;
    end else if (cnt_en && (count < MAX_COUNT)) begin
      count <= count + 1;
    end else begin
      count <= 8'h00;
    end
  end

endmodule