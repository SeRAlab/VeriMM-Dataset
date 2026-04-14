module four_bit_complement
  (output reg [3:0] Y, input [3:0] A, input S);
  
  always @(*) begin
    if(S == 0) begin
      Y = ~A + 4'b1;
    end
    else begin
      Y = ~A;
    end
  end
  
endmodule