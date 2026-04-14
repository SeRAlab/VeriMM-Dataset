module gray_code_counter_6 
(
  input rst,
  input clk,

  output reg [5:0] count
);

  reg [5:0] binary_count;

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      binary_count <= 6'b000000;
      count <= 6'b000000;
    end 
	else 
	begin
      binary_count <= binary_count + 1;
      count <= (binary_count >> 1) ^ binary_count;
    end
  end

endmodule