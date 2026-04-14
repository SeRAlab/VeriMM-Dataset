module top_module(input [3:0] a, input [3:0] b, input addSub, output reg [3:0] result);always @(*) begin
    if(addSub) begin
      result = a + b;
    end else begin
      result = a - b;
    end
  end
  
endmodule