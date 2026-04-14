module top_module(
  input clk,
  input reset,
  input [7:0] data,
  output reg match
);reg [7:0] prev_data;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    match <= 0;
    prev_data <= 0;
  end else begin
    if (data > prev_data) begin
      match <= 1;
    end else begin
      match <= 0;
    end
    prev_data <= data;
  end
end

endmodule