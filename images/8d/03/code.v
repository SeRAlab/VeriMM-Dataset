module shift_register(
  input clk,
  input rst_n,
  input serial_in,
  output reg [7:0] shift_reg
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      shift_reg <= 8'b0;
    end
    else begin
      shift_reg <= {shift_reg[6:0], serial_in};
    end
  end

endmodule