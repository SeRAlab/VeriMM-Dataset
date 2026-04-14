module nios_system_alu_carry_out (
  input [1:0] address,
  input clk,
  input in_port,
  input reset_n,
  output reg [31:0] readdata
);

  wire clk_en = 1;
  wire data_in = in_port;
  wire read_mux_out = (address == 0) ? data_in : 32'b0;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      readdata <= 0;
    end else if (clk_en) begin
      readdata <= {32'b0, read_mux_out};
    end
  end

endmodule