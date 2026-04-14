module top_module(
  input aclk,
  input s_dclk_o,
  input ENB_I,
  input ENA_I,
  input POR_B,
  input [3:0] RD_PNTR,
  input [3:0] WR_PNTR,
  input [63:0] Q,
  output reg [63:0] D,
  output reg p_20_out
);reg [63:0] mem [15:0]; // Memory array declared as reg
  reg [3:0] read_ptr;
  reg [3:0] write_ptr;

  always @(posedge aclk) begin
    if (~POR_B) begin // Changed to active low reset
      read_ptr <= 0;
      write_ptr <= 0;
    end else begin
      if (ENA_I) begin
        mem[write_ptr] <= Q; // Writing to memory
        write_ptr <= write_ptr + 1;
      end
      if (ENB_I) begin
        D <= mem[read_ptr]; // Reading from memory
        read_ptr <= read_ptr + 1;
      end
    end
  end

endmodule