module top_module(
  input clk,
  input reset,
  input data,
  output reg [2:0] count
);reg [2:0] next_count;
  
  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      count <= 0;
      next_count <= 0;
    end else begin
      if (data == 1) begin
        next_count <= count + 1;
      end else begin
        next_count <= 0;
      end
      
      count <= next_count;
    end
  end

endmodule