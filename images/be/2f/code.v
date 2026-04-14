module top_module(
  input clk,
  input [3:0] bin_in,
  output reg [3:0] gray_out // Changed from wire to reg
);reg [3:0] gray_reg;
  reg [1:0] state;

  always @(posedge clk) begin
    case (state)
      2'b00: begin // State 0
        state <= 2'b01;
      end
      2'b01: begin // State 1
        gray_reg[3] <= bin_in[3];
        gray_reg[2] <= bin_in[3] ^ bin_in[2];
        gray_reg[1] <= bin_in[2] ^ bin_in[1];
        gray_reg[0] <= bin_in[1] ^ bin_in[0];
        gray_out <= gray_reg; // No longer an error as gray_out is reg
        state <= 2'b00;
      end
      default: begin
        state <= 2'b00;
      end
    endcase
  end

endmodule