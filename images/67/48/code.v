module top_module(input ctrl0, ctrl1, 
     input D0, D1, D2, D3, 
     output reg S);always @(*) begin
    case ({ctrl1, ctrl0})
      2'b00: S = D0;
      2'b01: S = D1;
      2'b10: S = D2;
      2'b11: S = D3;
      default: S = 1'b0; // Handle case for default safety
    endcase
  end
endmodule