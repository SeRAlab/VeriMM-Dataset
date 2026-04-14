module gray_code_counter 
(
  input rst_n,
  input clk,
  input en,

  output reg [3:0] out
);

  reg [3:0] binary_count;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      binary_count <= 4'b0000;
      out <= 4'b0000;
    end 
	
	else if (en) 
	begin
      binary_count <= binary_count + 1;
      out <= (binary_count >> 1) ^ binary_count; // Convert binary count to Gray code
    end 
	
	else 
	begin
      binary_count <= binary_count; // Pause the count when en is invalid
      out <= out;
    end
  end

endmodule