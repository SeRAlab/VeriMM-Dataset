module piso_shift_register(
  input clk,
  input rst_n,
  input load,
  input [7:0] parallel_in,
  output reg serial_out
);

  reg [7:0] shift_reg;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      shift_reg <= 8'b00000000;
      serial_out <= 0;
    end
    else begin
      if (load) begin
        shift_reg <= parallel_in;
      end
      else begin
        serial_out <= shift_reg[0];
        shift_reg <= shift_reg >> 1;
      end
    end
  end

endmodule