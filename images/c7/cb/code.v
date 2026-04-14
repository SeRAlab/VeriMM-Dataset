module parity_checker (
  input [2:0] data,
  output reg parity
);
  
  always @(*) begin
    parity = (data[0] ^ data[1] ^ data[2]);
  end
  
endmodule
