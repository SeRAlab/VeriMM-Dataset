module top_module(
  input clk,
  input reset,
  output reg [3:0] counter_out
);always @(posedge clk) begin
    if (reset) begin
      counter_out <= 4'b0000;
    end else begin
      case (counter_out)
        4'b0000: counter_out <= 4'b0001;
        4'b0001: counter_out <= 4'b0010;
        4'b0010: counter_out <= 4'b0100;
        4'b0100: counter_out <= 4'b1000;
        4'b1000: counter_out <= 4'b0000;
      endcase
    end
  end

endmodule