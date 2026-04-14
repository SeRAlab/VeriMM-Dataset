module top_module(
  input clk,
  input [1:0] select,
  input write_enable,
  input [15:0] write_data,
  inout [15:0] data_in_0,
  inout [15:0] data_in_1,
  inout [15:0] data_in_2,
  inout [15:0] data_in_3,
  output reg [15:0] data_out  // Change inout to output reg
);reg [15:0] data_internal_0;
  reg [15:0] data_internal_1;
  reg [15:0] data_internal_2;
  reg [15:0] data_internal_3;

  always @(posedge clk) begin
    if (write_enable) begin
      case (select)
        2'b00: data_internal_0 <= write_data;
        2'b01: data_internal_1 <= write_data;
        2'b10: data_internal_2 <= write_data;
        2'b11: data_internal_3 <= write_data;
      endcase
    end
  end

  assign data_in_0 = (select == 2'b00) ? data_internal_0 : 16'bz; // Use high-impedance for inactive inputs
  assign data_in_1 = (select == 2'b01) ? data_internal_1 : 16'bz;
  assign data_in_2 = (select == 2'b10) ? data_internal_2 : 16'bz;
  assign data_in_3 = (select == 2'b11) ? data_internal_3 : 16'bz;

  always @(posedge clk) begin
    case (select)
      2'b00: data_out <= data_internal_0;
      2'b01: data_out <= data_internal_1;
      2'b10: data_out <= data_internal_2;
      2'b11: data_out <= data_internal_3;
      default: data_out <= 16'b0; // Default case added
    endcase
  end

endmodule