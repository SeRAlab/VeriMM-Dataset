module BLOCK1A ( PIN2, GIN1, GIN2, PHI, GOUT );

input  PIN2;
input  GIN1;
input  GIN2;
input  PHI;
output GOUT;

reg    GOUT;

always @(posedge PHI) begin
   GOUT =  ~ (GIN2 & (PIN2 | GIN1));
end

endmodule