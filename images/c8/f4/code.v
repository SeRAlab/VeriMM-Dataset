module v306ca3_v9a2a06 (
 input [15:0] i,
 output reg [7:0] o1,
 output reg [7:0] o0
);
 always @(*) begin
  o1 = i[15:8];
  o0 = i[7:0];
 end
endmodule