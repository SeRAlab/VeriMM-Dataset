module top_module(Q_, G1A,G1B, D);output Q_; 
input  G1A, G1B, D;

       reg Q_;

always @ (G1A or G1B or D) begin

       if ((G1A==1) & (G1B==1))    Q_ <= #1 ~D;

end

endmodule