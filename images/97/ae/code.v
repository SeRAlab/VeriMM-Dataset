module top_module(
  input [3:0] in_data,
  input [1:0] ctrl,
  output reg [3:0] out_data
);always @(*)
  begin
    case (ctrl)
      2'b00: out_data = ~in_data;
      2'b01: out_data = ~in_data + 1;
      2'b10: out_data = {in_data[2:0], 1'b0};
      2'b11: out_data = {1'b0, in_data[3:1]};
      default: out_data = 4'b0;
    endcase
  end

endmodule