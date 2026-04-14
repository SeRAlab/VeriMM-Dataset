module binary_counter_2bit 
(
  input rst_n,
  input clk,
  input enable,

  output reg [1:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 2'b00;
    end 

	else if (enable) 
	begin
      if (count == 2'b11) 
	  begin
        count <= 2'b00;
      end 
	  else begin
        count <= count + 1;
      end
    end 
	
	else begin
      count <= count; // Pause the count when enable is inactive
    end
  end

endmodule