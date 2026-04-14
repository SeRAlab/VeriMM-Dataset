module top_module(A, B, M, Y, O);input [3:0] A, B;
  input M;
  output reg [3:0] Y;  // Changed from wire to reg
  output reg O;        // Changed from wire to reg
  
  reg [4:0] temp;
  
  always @* begin
    if (M == 0) begin
      temp = A + B;
      Y = temp[3:0];
      O = temp[4];
    end
    else begin
      temp = A - B;
      Y = temp[3:0];
      O = temp[4];
    end
  end
  
endmodule