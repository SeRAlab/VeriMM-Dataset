module shift_register_8 
(
  input rst,
  input clk,
  input load,
  input shift,
  input [7:0] parallel_in,

  output reg [7:0] data_out
);

  always @(posedge clk or posedge rst) begin
    if (rst) 
	begin
      data_out <= 8'b00000000;
    end 
	
	else if (load) 
	begin
      data_out <= parallel_in;
    end 
	
	else if (shift) 
	begin
      data_out <= data_out >> 1;
    end 
	
	else begin
      data_out <= data_out; // Maintain current value when neither load nor shift is high
    end
  end

endmodule