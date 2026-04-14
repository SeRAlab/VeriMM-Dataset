module d_flip_flop (
  input clk,
  input reset,
  input [7:0] data_in,
  output reg [7:0] data_out
);

  always @(posedge clk) begin
    if (reset) begin
      data_out <= 8'd0;
    end else begin
      data_out <= data_in;
    end
  end
  
endmodule
