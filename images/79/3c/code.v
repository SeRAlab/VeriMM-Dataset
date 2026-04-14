module top_module(
    input E,     // Enable
    input SE,    // Scan enable
    input CK,    // Clock
    output ECK   // Clock gated output
);// Simple behavior for demonstration
  reg ECK_reg;
  
  always @(posedge CK) begin
    if (E) begin
      ECK_reg <= 1'b1; // or some logic based on your requirement
    end else begin
      ECK_reg <= 1'b0;
    end
  end
  
  assign ECK = ECK_reg;
endmodule