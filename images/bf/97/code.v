module debounce(
  input clk,
  input rst_n,
  input noisy_button,
  output reg clean_button
);

  reg [3:0] shift_reg;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      shift_reg <= 4'b0;
      clean_button <= 1'b0;
    end
    else begin
      shift_reg <= {shift_reg[2:0], noisy_button};
      
      if (shift_reg == 4'b1111)
        clean_button <= 1'b1;
      else
        clean_button <= 1'b0;
    end
  end

endmodule