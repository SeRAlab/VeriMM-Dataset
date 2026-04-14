module adder_8bit(
  input [7:0] A,
  input [7:0] B,
  input enable,
  output reg [7:0] C
);

  always @(*) begin
    if(enable) begin
      C <= A + B;
    end else begin
      C <= 8'b0;
    end
  end
  
endmodule