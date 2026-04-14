module top_module(
  input [7:0] in_vector,
  output reg [7:0] out_vector
);always @(*) begin
    out_vector[0] = in_vector[1];
    out_vector[1] = in_vector[0];
    out_vector[2] = in_vector[3];
    out_vector[3] = in_vector[2];
    out_vector[4] = in_vector[5];
    out_vector[5] = in_vector[4];
    out_vector[6] = in_vector[7];
    out_vector[7] = in_vector[6];
  end
  
endmodule