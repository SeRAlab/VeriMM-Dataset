module top_module(Z, A, B, ctrl);input [3:0] A, B;
  input ctrl;
  output reg [3:0] Z;
  
  always @ (A, B, ctrl) begin
    if (ctrl == 0) begin
      Z = A + B;
    end
    else begin
      Z = A - B;
    end
  end
  
endmodule