module top_module(
  input [n-1:0] in,
  input shift_dir,
  input shift_mode,
  input clk,
  input reset,
  output [m-1:0] out
);parameter n = 8; // number of input bits
parameter m = 8; // number of output bits
parameter p = 4; // number of bits to shift
parameter q = 0; // shift mode (0 for serial, 1 for parallel)

reg [n-1:0] shift_reg; // shift register
reg [m-1:0] out_reg; // output register

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
    out_reg <= 0;
  end else begin
    if (shift_dir) begin
      if (shift_mode) begin // parallel shift
        out_reg <= {in[(n-1):(n-p)], shift_reg[(p-1):0]};
        shift_reg <= in;
      end else begin // serial shift
        out_reg <= {in[n-1], shift_reg[(n-2):0]};
        shift_reg <= {in[(n-2):0], 1'b0};
      end
    end else begin
      if (shift_mode) begin // parallel shift
        out_reg <= {shift_reg[(m-p-1):0], in[(n-p-1):0]};
        shift_reg <= in;
      end else begin // serial shift
        out_reg <= {shift_reg[(n-1)], in[0]};
        shift_reg <= {shift_reg[(n-2):0], in[n-1]};
      end
    end
  end
end

assign out = out_reg;

endmodule