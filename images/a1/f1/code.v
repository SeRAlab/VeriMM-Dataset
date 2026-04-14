module top_module(input TxClk, input TxReset, input Tx1, input Tx0, output reg D, output reg S);wire nextD = Tx1; 
  wire nextS = (Tx0 & ~(D^S)) | (Tx1 & (D^S)); 

  always @(posedge TxClk or posedge TxReset) begin 
    if(TxReset) begin 
      D <= 1'b0; 
      S <= 1'b0; 
    end 
    else if(Tx0 | Tx1) begin 
      D <= nextD; 
      S <= nextS; 
    end 
  end 
endmodule