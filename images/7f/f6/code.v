module top_module(A, B, Sel, Z);input A;
input B;
input Sel;
output Z;

  reg Z;

  always @ (A, B, Sel)
    begin
      if (Sel == 0)
        Z = A;
      else
        Z = B;
    end

endmodule