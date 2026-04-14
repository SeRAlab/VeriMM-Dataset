module mux_4to1_enable (
  input [7:0] data0,
  input [7:0] data1,
  input [7:0] data2,
  input [7:0] data3,
  input enable,
  input [1:0] sel,
  output reg [7:0] out
);

  always @ (sel or enable or data0 or data1 or data2 or data3) begin
    if (enable == 1'b0) begin
      out <= 8'b0;
    end else begin
      case (sel)
        2'b00: out <= data0;
        2'b01: out <= data1;
        2'b10: out <= data2;
        2'b11: out <= data3;
      endcase
    end
  end

endmodule
