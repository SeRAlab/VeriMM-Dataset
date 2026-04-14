module fletcher (
  input [n*8-1:0] data,
  output reg [15:0] checksum
);

parameter n = 4; // number of data blocks

reg [7:0] s1 [0:n-1];
reg [7:0] s2 [0:n-1];

integer i, j;

always @(*) begin
  for (i = 0; i < n; i = i + 1) begin
    s1[i] = 0;
    s2[i] = 0;
    for (j = i*8; j < (i+1)*8; j = j + 1) begin
      s1[i] = s1[i] + data[j];
      s2[i] = s2[i] + s1[i];
    end
  end
  checksum = {s1[n-1], s2[n-1]};
end

endmodule