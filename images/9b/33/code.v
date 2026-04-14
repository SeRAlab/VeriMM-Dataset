module top_module(DOUTB,
    clk,
    ENB,
    E,
    Q,
    ADDRB,
    ADDRA,
    din);output reg [93:0] DOUTB; // Changed to reg type
  input clk;
  input ENB;
  input [0:0] E;
  output [0:0] Q; // Changed to output type
  input [5:0] ADDRB;
  output [5:0] ADDRA; // Changed to output type
  input [93:0] din;

  reg [5:0] write_ptr;
  reg [5:0] read_ptr;
  reg [93:0] mem [0:63];
  wire [5:0] filled;
  wire [5:0] empty;

  assign filled = write_ptr - read_ptr;
  assign empty = 64 - filled;

  always @(posedge clk) begin
    if (ENB) begin
      if (filled < 64) begin
        mem[write_ptr] <= din;
        write_ptr <= write_ptr + 1;
      end
    end
    if (E) begin
      if (filled > 0) begin
        DOUTB <= mem[read_ptr];
        read_ptr <= read_ptr + 1;
      end
    end
  end

  assign Q = (filled > 0);
  assign ADDRA = read_ptr;
  assign ADDRB = write_ptr;
  assign E = (filled == 0);

endmodule