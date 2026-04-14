module top_module(
  input [31:0] in_vector,
  output reg [31:0] out_vector
);always @* begin
    out_vector[31:24] = in_vector[7:0];
    out_vector[23:16] = in_vector[15:8];
    out_vector[15:8] = in_vector[23:16];
    out_vector[7:0] = in_vector[31:24];
  end

endmodule