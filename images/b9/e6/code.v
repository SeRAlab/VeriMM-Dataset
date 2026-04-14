module top_module(
  input wire [15:0] data_in,
  output reg [7:0] upper_byte,
  output reg [7:0] lower_byte
);always @(*) begin
    upper_byte = data_in[15:8];
    lower_byte = data_in[7:0];
  end

endmodule