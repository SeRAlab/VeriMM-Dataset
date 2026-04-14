module gray_code_counter (
  input clk,
  input en,
  input rst,
  output reg [8:0] gray_count);

reg [8:0] bin_count;

always @(posedge clk) begin
    if (rst) begin
        bin_count <= 9'b000000000;
        gray_count <= 9'b000000000;
    end else if (en) begin
        bin_count <= bin_count + 1;
        gray_count <= bin_count ^ (bin_count >> 1);
    end
end
endmodule