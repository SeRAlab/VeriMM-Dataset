module bin2gray (
  input clk,
  input [3:0] bin,
  output reg [3:0] gray
);

reg [3:0] prev_bin;

always @(posedge clk) begin
  if (bin !== prev_bin) begin
    gray[3] = bin[3];
    gray[2] = bin[3] ^ bin[2];
    gray[1] = bin[2] ^ bin[1];
    gray[0] = bin[1] ^ bin[0];
    prev_bin <= bin;
  end
end

endmodule
