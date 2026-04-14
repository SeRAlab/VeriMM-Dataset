module verified_shift_register 
(
  input rst_n,
  input clk,
  input load,
  input [7:0] data_in,

  output reg [7:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      q <= 8'b00000000;
    end 

	else 
	begin
      if (load) 
	  begin
        q <= data_in;
      end 
	  else 
	  begin
        q <= {q[6:0], 1'b0};
      end
    end
  end

endmodule