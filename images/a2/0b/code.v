module top_module(
  input clk,
  input reset,
  input [7:0] data,
  output reg [3:0] count
);reg [3:0] temp_count;

always @(posedge clk) begin
  if (reset) begin
    count <= 0;
    temp_count <= 0;
  end
  else begin
    if (data == 8'b11111111) begin
      count <= 8;
      temp_count <= 8;
    end
    else if (data == 8'b00000000) begin
      count <= 0;
      temp_count <= 0;
    end
    else begin
      if (data[7] == 1) begin
        temp_count <= temp_count + 1;
        count <= temp_count;
      end
      else begin
        temp_count <= 0;
        count <= 0;
      end
    end
  end
end

endmodule