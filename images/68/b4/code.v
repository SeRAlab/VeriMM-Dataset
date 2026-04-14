module shift_register 
(
  input rst_n,
  input clk,
  input enable,
  input shift_dir,

  output reg [7:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      q <= 8'b00000000;
    end 
	
	else if (enable) 
	begin
      if (shift_dir) 
	  begin
        q <= q << 1;
      end 
	  
	  else begin
        q <= q >> 1;
      end
    end 
	
	else begin
      q <= q; // Pause the shift when enable is invalid
    end
  end

endmodule