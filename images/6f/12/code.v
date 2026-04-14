module top_module(
  input [7:0] data_in,
  output reg parity_bit
);reg [2:0] count;
  integer i;
  
  always @(*) begin
    count = 0;
    for (i = 0; i < 8; i = i + 1) begin
      count = count + data_in[i];
    end
    parity_bit = (count % 2 == 1);
  end
  
endmodule