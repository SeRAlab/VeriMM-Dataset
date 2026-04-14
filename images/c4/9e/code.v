module edge_detection(
  input wire clk,
  input wire rst,
  input wire [9:0] in_data,
  input wire [3:0] threshold,
  output reg [9:0] out_data
);

  reg [9:0] prev_data;
  reg [9:0] diff;
  
  always @(posedge clk) begin
    if (rst) begin
      prev_data <= 0;
      out_data <= 0;
    end else begin
      diff <= in_data - prev_data;
      prev_data <= in_data;
      if (diff > threshold) begin
        out_data <= 10'h3FF;
      end else begin
        out_data <= 0;
      end
    end
  end

endmodule