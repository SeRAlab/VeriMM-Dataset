module decoder_4to16 (
  input [3:0] binary,
  output reg [15:0] one_hot);
  
always @(*) begin
    one_hot = 16'b0;
    one_hot[binary] = 1'b1;
end
endmodule