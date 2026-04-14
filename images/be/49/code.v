module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg [2:0] count
);reg [2:0] count_reg;
reg [2:0] count_next;

always @(posedge clk) begin
  if (reset) begin
    count_reg <= 0;
  end else begin
    count_reg <= count_next;
  end
end

always @(*) begin
  count_next = 0;
  if (data[0] == 1) begin
    count_next = 1;
    if (data[1] == 1) begin
      count_next = 2;
      if (data[2] == 1) begin
        count_next = 3;
      end
    end
  end
end

assign count = count_reg;

endmodule