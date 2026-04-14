module top_module(
  input clk,
  input reset,
  output osc_out
);reg [15:0] count;
  reg osc_state;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      count <= 16'd0;
      osc_state <= 1'b0;
    end else begin
      count <= count + 1;
      if (count == 16'd32768) begin
        count <= 16'd0;
        osc_state <= ~osc_state;
      end
    end
  end

  assign osc_out = osc_state;

endmodule