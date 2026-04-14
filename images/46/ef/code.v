module top_module(
  input [31:0] A,
  input [31:0] B,
  output reg [31:0] C
);// No parameters needed for this module.
  
  always @(*) begin
    if (B == 0) begin
      $display("Error: division by zero");
      C <= 0;
    end else begin
      C <= A % B;
      if (C < 0) begin
        C <= C + B;
      end
    end
  end

endmodule