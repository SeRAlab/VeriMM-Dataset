module top_module(
  input clk,
  input reset,
  output reg [15:0] count
);always @(posedge clk) begin
    if(reset) begin
      count <= 16'd0;
    end
    else begin
      count <= count + 16'd1;
    end
  end

endmodule