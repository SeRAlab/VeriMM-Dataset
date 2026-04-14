module top_module(
  input clk,
  input reset,
  output reg [3:0] count
);reg [3:0] temp_count;

always @(posedge clk) begin
  if (reset) begin
    temp_count <= 4'b0000;
  end
  else begin
    if (temp_count == 4'b0111) begin
      temp_count <= 4'b0000;
    end
    else begin
      temp_count <= temp_count + 1;
    end
  end
end

assign count = temp_count;

endmodule