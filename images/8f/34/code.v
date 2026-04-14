module binary_counter
(
  input rst_n,
  input clk,
  input enable,
  input count_dir,

  output reg [3:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 4'b0000;
    end 
	
	else if (enable) 
	begin
      if (count_dir) 
	  begin
        count <= count + 1;
      end 
	  
	  else begin
        count <= count - 1;
      end
    end 
	
	else begin
      count <= count; // Pause the counter when enable is invalid
    end
  end

endmodule