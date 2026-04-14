module top_module(Euncomp, Ecomp);parameter Wc=32;
parameter Wcbits = 5;
parameter W=6;
parameter Wabs=W-1;
parameter ECOMPSIZE = (2*(W-1))+Wcbits+Wc;
output[(Wc*W)-1:0] Euncomp; 
input[ECOMPSIZE-1:0] Ecomp;



wire[Wabs-1:0] Min1mag, Min2mag;
wire[W-1:0] posMin1, negMin1, posMin2, negMin2;
wire [Wcbits-1:0] Pos;
wire [Wc-1:0] UpdatedSign;

reg [W-1:0] E[Wc-1:0];
wire [Wc-1:0] poseq;



assign {Min1mag, Min2mag, Pos, UpdatedSign} = Ecomp;


genvar i;
generate for(i=0;i<=Wc-1;i=i+1) begin: loop1
  
  always@(*)
  begin  
    case({Pos == i,UpdatedSign[i]})
      2'b00: E[i] = {1'b0,Min1mag};
      2'b01: E[i] = {1'b1,~Min1mag}+1'b1;
      2'b10: E[i] = {1'b0,Min2mag};
      2'b11: E[i] = {1'b1,~Min2mag}+1'b1;
     
    endcase
  end
  
  
assign Euncomp[((i+1)*W)-1:(i*W)] = E[i];
end
endgenerate

endmodule