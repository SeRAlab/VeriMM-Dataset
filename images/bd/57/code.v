module johnson_counter_6bit 
(
  input reset,
  input clk,
  input enable,

  output reg [5:0] count
);

  always @(posedge clk or posedge reset) begin
    if (reset) 
	begin
      count <= 6'b000001;
    end 
	
	else if (enable) 
	begin
      count <= {~count[5], count[5:1]};
    end
  end

endmodule