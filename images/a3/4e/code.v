module gray_code_counter(
  input clk,
  input rst_n,
  output reg [2:0] gray_code
);

  reg [2:0] count;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      count <= 3'b0;
    end
    else begin
      count <= count + 1;
    end
  end

  always @(*) begin
    gray_code = count ^ (count >> 1);
  end

endmodule