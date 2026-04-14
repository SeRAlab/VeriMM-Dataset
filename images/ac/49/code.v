module top_module(PRODUCT, A, B);output reg signed [7:0] PRODUCT;
  input signed [3:0] A, B;

  reg [1:0] temp;
  integer i;
  reg e;
  reg [3:0] B1;

  always @(A,B)
  begin
    PRODUCT = 8'd0;
    e = 1'b0;
    B1 = -B;
    
    for (i=0; i<4; i=i+1)
    begin
      temp = { A[i], e };
      case(temp)
        2'd2 : PRODUCT[7:4] = PRODUCT[7:4] + B1;
        2'd1 : PRODUCT[7:4] = PRODUCT[7:4] + B;
      endcase
      PRODUCT = PRODUCT >> 1;
      PRODUCT[7] = PRODUCT[6];
      e=A[i];
      
    end
  end
  
endmodule