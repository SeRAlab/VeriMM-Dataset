module johnson_counter_8 
(
  input rst,
  input clk,
  input enable,

  output reg [7:0] johnson_count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      johnson_count <= 8'b00000000;
    end 
	
	else if (enable) 
	begin
      johnson_count <= {johnson_count[6:0], ~johnson_count[7]};
    end 
	
	else begin
      johnson_count <= johnson_count; // Pause the count when enable is low
    end
  end

endmodule