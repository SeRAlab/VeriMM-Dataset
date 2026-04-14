module top_module(
  input                clk,
  input                rst_n,
  input                select,
  output reg  [63:0]   Q
);reg [31:0] reg1, reg2;
  reg [5:0] lfsr;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      reg1 <= 0;
      reg2 <= 0;
      lfsr <= 0;
      Q <= 0;
    end else begin
      if (select) begin
        // LFSR mode
        lfsr[5] <= lfsr[4] ^ lfsr[0];
        lfsr[4] <= lfsr[3];
        lfsr[3] <= lfsr[2];
        lfsr[2] <= lfsr[1];
        lfsr[1] <= lfsr[0];
        lfsr[0] <= lfsr[5];
        Q <= {lfsr, lfsr};
      end else begin
        // Register mode
        reg1 <= {reg1[30:0], reg2[31]};
        reg2 <= {reg2[30:0], reg1[31]};
        Q <= {reg2, reg1};
      end
    end
  end

endmodule