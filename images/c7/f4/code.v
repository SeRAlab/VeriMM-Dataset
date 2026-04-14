module subtractor (
  input clk,
  input [7:0] A,
  input [7:0] B,
  output reg [7:0] Y
);

  always @(posedge clk) begin
    if (A < B) begin
      Y <= 8'b0;
    end else begin
      Y <= A - B;
    end
  end
  
endmodule