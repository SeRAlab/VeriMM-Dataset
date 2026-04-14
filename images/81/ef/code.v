module johnson_counter (
  input clk,
  input reset,
  input enable,
  output reg [5:0] count
);

  always @(posedge clk) begin
    if (reset) begin
      count <= 6'b000000;
    end
    else if (enable) begin
      count <= {~count[5], count[5:1]};
    end
  end

endmodule