module top_module(
  input clk,
  input reset,
  input load,
  input [3:0] din,
  output reg [3:0] sro
);always @(posedge clk) begin
    if(reset) begin
      sro <= 4'b0000;
    end else if(load) begin
      sro <= din;
    end else begin
      sro <= {sro[2:0], din[3]};
    end
  end

endmodule