module TLATNTSCAX2TS ( E, SE, CK, ECK );
  input E, SE, CK;
  output ECK;

  reg ECK;

  always @(posedge CK) begin
    if (SE) begin
      ECK <= 1'b1;
    end else if (E) begin
      ECK <= 1'b0;
    end
  end
endmodule