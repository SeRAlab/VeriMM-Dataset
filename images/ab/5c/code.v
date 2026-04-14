module top_module(
    input [31:0] INA,
    input [31:0] INB,
    output [31:0] OP
    );genvar i;
    generate
         for(i=0;i<=31;i=i+1)
         begin
         xnor x(OP[i],INA[i],INB[i]);
         end
    endgenerate
endmodule