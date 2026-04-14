module register_16 
(
  input clk,
  input load,
  input clear,
  input [15:0] D,

  output reg [15:0] Q
);

  always @(posedge clk) begin
    if (clear) 
	begin
      Q <= 16'b0;
    end 
	
	else if (load) 
	begin
      Q <= D;
    end
  end

endmodule