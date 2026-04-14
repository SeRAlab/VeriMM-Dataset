module top_module(
  input [7:0] in_vec,
  output reg [7:0] out_vec
);integer i;
reg temp;

always @(*) begin
  for(i=0; i<4; i=i+1) begin
    temp = in_vec[i];
    out_vec[i] = in_vec[7-i];
    out_vec[7-i] = temp;
  end
end

endmodule