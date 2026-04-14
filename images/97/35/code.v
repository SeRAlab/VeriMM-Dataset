module top_module(
  input [3:0] data,
  output reg [3:0] led_display
);always @(*) begin
    case(data)
      4'b0001: led_display = 1;
      4'b0010: led_display = 2;
      4'b0100: led_display = 3;
      4'b1000: led_display = 4;
      default: led_display = 0;
    endcase
  end

endmodule