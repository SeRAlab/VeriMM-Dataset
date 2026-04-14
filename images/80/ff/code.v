module top_module(
  input clk,
  input reset,
  input data,
  output reg [7:0] count
);reg prev_data;
  
  always @(posedge clk) begin
    if (reset) begin
      count <= 0;
      prev_data <= 0;
    end else begin
      if (data && !prev_data) begin
        count <= count + 1;
      end
      prev_data <= data;
    end
  end

endmodule