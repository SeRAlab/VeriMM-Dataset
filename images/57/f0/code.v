module top_module(IN1,IN2,SUM);input [15:0]IN1; 
input[15:0]IN2;
output reg [16:0]SUM;



always @(*) 
  begin

    SUM = IN1+IN2;
  end

endmodule