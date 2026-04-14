module top_module(
  input [7:0] data,
  output reg match
);always @(*) begin
    match = ((data[3:0] & 4'b1111) == 4'b1010);
  end
  
endmodule