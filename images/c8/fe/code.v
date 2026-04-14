module compare_and_operate (
  input [3:0] A,
  input [3:0] B,
  output reg [4:0] C
);

  always @(*) begin
    C = (A < B) ? (A + B) : ((A > B) ? (A - B) : (A | B));
  end
  
endmodule
