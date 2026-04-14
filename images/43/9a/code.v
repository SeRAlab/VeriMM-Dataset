module top_module(
  input iA,
  input iB,
  output oSUM,
  output oCARRY
);assign oSUM = iA ^ iB;

  
  assign oCARRY = iA & iB;
endmodule