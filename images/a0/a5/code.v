module ring_counter_6 
(
  input rst,
  input clk,
  input enable,

  output reg [5:0] ring_count
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      ring_count <= 6'b000001; // Seed value
    end 
	
	else if (enable) 
	begin
      ring_count <= {ring_count[4:0], ring_count[5]};
    end 
	
	else begin
      ring_count <= ring_count; // Pause the count when enable is low
    end
  end

endmodule