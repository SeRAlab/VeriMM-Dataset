module top_module(input [3:0] a, output reg [3:0] b);// Change b to output reg

  always @(*) begin
    if (a <= 4) begin
      b = a * 2;
    end else begin
      b = a / 2;
    end
  end

endmodule