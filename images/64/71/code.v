module top_module(
  input a,
  input b,
  input reset,
  output reg final_output
);// MUX implementation using non-clocked always block
  always @ (a, b)
  begin
    if (reset) begin
      final_output = 1'b0; // Reset final_output on reset signal
    end else if (a == 1'b0) begin
      final_output = b;
    end else begin
      final_output = a;
    end
  end
  
  // Decoder implementation using NAND gates
  wire nand1, nand2, nand3;
  assign nand1 = ~(a & b);
  assign nand2 = ~(a & nand1);
  assign nand3 = ~(b & nand1);
  
  // Update final_output to be the result of the NAND gates
  always @ (*)
  begin
    final_output = ~(nand2 & nand3);
  end
  
endmodule