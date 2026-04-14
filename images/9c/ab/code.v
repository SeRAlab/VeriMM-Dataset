module debouncer 
(
  input clk,
  input button_in,

  output reg button_out
);

  reg [7:0] shift_reg;

  always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], button_in};
    if (shift_reg == 8'b11111111) 
	begin
      button_out <= 1'b1;
    end 
	else if (shift_reg == 8'b00000000) 
	begin
      button_out <= 1'b0;
    end
  end

endmodule