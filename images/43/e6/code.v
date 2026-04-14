module top_module(
  input [3:0] binary_num,
  output reg [3:0] bcd_num,
  output reg error
);reg [7:0] bcd_temp;
  reg [1:0] i;
  
  always @(*) begin
    if (binary_num > 9) begin
      error = 1;
      bcd_temp = 0;
    end else begin
      error = 0;
      bcd_temp = {4'b0000, binary_num}; // Properly initialize bcd_temp
      for (i = 0; i < 4; i = i + 1) begin
        if (bcd_temp[7:4] > 4) begin
          bcd_temp[7:4] = bcd_temp[7:4] + 3;
        end
        bcd_temp = bcd_temp << 1;
      end
    end
    bcd_num = bcd_temp[7:4]; // Assign after all modifications
  end
  
endmodule