module top_module(
  input clk,
  input reset,
  input [15:0] data,
  output reg [15:0] edge_detected
);reg [15:0] prev_data;
  reg [15:0] curr_data;

  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      prev_data <= 16'b0;
      curr_data <= 16'b0;
      edge_detected <= 16'b0;
    end
    else begin
      prev_data <= curr_data;
      curr_data <= data;

      if (prev_data != curr_data) begin
        edge_detected <= curr_data ^ prev_data;
      end
    end
  end

endmodule