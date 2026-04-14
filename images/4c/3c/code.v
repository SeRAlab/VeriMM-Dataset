module top_module(
  input [7:0] bin,
  output reg [7:0] gray  // Changed to reg type to allow assignment in always block
);reg [7:0] gray_temp;
  integer i;
  
  always @* begin
    gray_temp[0] = bin[0];
    for(i = 1; i < 8; i = i + 1) begin
      gray_temp[i] = bin[i] ^ gray_temp[i - 1];
    end
    gray = gray_temp;  // This assignment is now valid since gray is reg type
  end
endmodule