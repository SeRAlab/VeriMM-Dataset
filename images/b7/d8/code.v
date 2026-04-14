module gray_code_counter(
  input clk,
  input rst_n,
  output reg [3:0] gray
);

  reg [3:0] binary_count;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      binary_count <= 4'b0;
      gray <= 4'b0;
    end
    else begin
      binary_count <= binary_count + 1;
      gray <= binary_count ^ (binary_count >> 1);
    end
  end

endmodule