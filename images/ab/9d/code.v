module top_module(
  input clk,
  input reset,
  output reg [2:0] count
);reg [2:0] next_count;

  always @(posedge clk) begin
    if (reset) begin
      next_count <= 3'b000;
    end else if (count == 3'b111) begin
      next_count <= 3'b000;
    end else begin
      next_count <= count + 3'b001;
    end
  end

  always @(posedge clk) begin
    count <= next_count;
  end

endmodule