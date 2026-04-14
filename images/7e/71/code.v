module top_module(
  input clk,
  input resetn,
  input parallel_load,
  input serial_in,
  output serial_out
);reg [15:0] shift_reg;

  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      shift_reg <= 16'b0;
    end
    else if (parallel_load) begin
      shift_reg <= serial_in;
    end
    else begin
      shift_reg <= {shift_reg[14:0], 1'b0};
    end
  end

  assign serial_out = shift_reg[15];

endmodule