module top_module(
  input [7:0] data,
  output reg parity_bit
);integer i;
  reg [7:0] temp_data;
  reg [3:0] count;
  
  always @* begin
    temp_data = data;
    count = 0;
    for(i=0; i<8; i=i+1) begin
      count = count + temp_data[i];
    end
    if(count % 2 == 1) begin
      parity_bit = 1;
    end
    else begin
      parity_bit = 0;
    end
  end
  
endmodule