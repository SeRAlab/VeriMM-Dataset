module shift_register
(
  input clk,
  input rst_n,
  input serial_in,
  output reg serial_out,
  output reg [3:0] parallel_out
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      parallel_out <= 4'b0000;
      serial_out <= 1'b0;
    end 
	else 
	begin
      serial_out <= parallel_out[0];
      parallel_out <= {serial_in, parallel_out[3:1]};
    end
  end

endmodule