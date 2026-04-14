module top_module(
  input clk,
  input reset,
  input valid_input,
  output reg [9:0] count
);reg [9:0] temp_count;
reg [3:0] valid_count;

always @(posedge clk) begin
  if (reset) begin
    temp_count <= 10'b0;
    valid_count <= 4'b0;
    count <= 10'b0;
  end
  else if (valid_input) begin
    if (valid_count == 4'b1111) begin
      temp_count <= temp_count + 10'b1;
      valid_count <= 4'b0;
      if (temp_count == 10'd1000) begin
        temp_count <= 10'b0;
      end
    end
    else begin
      valid_count <= valid_count + 4'b1;
    end
    count <= temp_count;
  end
end

endmodule