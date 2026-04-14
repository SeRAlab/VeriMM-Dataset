module top_module(
  input [2:0] sel,
  input [3:0] data0,
  input [3:0] data1,
  input [3:0] data2,
  input [3:0] data3,
  input [3:0] data4,
  input [3:0] data5,
  output reg [3:0] out,
  output reg parity
);reg [3:0] selected_data;
  reg [1:0] add_result;

  always @(*) begin
    case (sel)
      3'b000: selected_data = data0;
      3'b001: selected_data = data1;
      3'b010: selected_data = data2;
      3'b011: selected_data = data3;
      3'b100: selected_data = data4;
      3'b101: selected_data = data5;
      default: selected_data = 4'b0000;
    endcase
  end

  always @(*) begin
    add_result = selected_data[1:0] - selected_data[3:2];
  end

  always @(*) begin
    out = {add_result, selected_data[3:2]};
    parity = ~^out;
  end

endmodule