module top_module(
  input[7:0] a,b,
  input enable,
  output greater
  );wire [7:0] a_x_not_b;
wire [7:0] anb = a & ~b;
wire [7:0] aeqb = (a & b) | (~a & ~b);
wire [7:0] part;

genvar i,j;
assign part[7] = anb[7];
for( i = 6; i > -1; i = i - 1) begin
  assign part[i] = anb[6];
  for (j = 7; j > i; j = j - 1) begin
    assign part[i] = part[i] & aeqb[j];
  end
end
assign greater = part[0];
for (i = 1; i < 8; i = i + 1) begin
  assign greater = greater | part[i];
end
endmodule