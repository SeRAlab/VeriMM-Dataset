module top_module(
  input clk, rst,
  input [3:0] data_in,
  input [1:0] shift_amount,
  output [3:0] data_out
);reg [3:0] shifted_data;

always @(posedge clk, negedge rst) begin
  if (!rst) begin
    shifted_data <= 4'b0;
  end else begin
    case(shift_amount)
      2'b00: shifted_data <= data_in;
      2'b01: shifted_data <= {data_in[2:0], 1'b0};
      2'b10: shifted_data <= {data_in[1:0], 2'b0};
      2'b11: shifted_data <= {data_in[0], 3'b0};
      default: shifted_data <= 4'b1;
    endcase
  end
end

assign data_out = shifted_data;

endmodule