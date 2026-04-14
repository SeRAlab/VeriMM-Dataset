module top_module(
input wire  wA,wB,wCi,
output wire  wR ,
output wire wCo
);assign {wCo,wR} = wA + wB + wCi;
endmodule