module top_module(
  input clk,
  input clkx2,
  input jrst_n,
  input [35:0] tw,
  output reg tr_clk,  // Change tr_clk from wire to reg
  output reg [17:0] tr_data
);reg x1;
  reg x2;
  wire phase;

  assign phase = x1 ^ x2;

  always @(posedge clk or negedge jrst_n) begin
    if (~jrst_n) begin
      x1 <= 0;
    end else begin
      x1 <= ~x1;
    end
  end

  always @(posedge clkx2 or negedge jrst_n) begin
    if (~jrst_n) begin
      x2 <= 0;
      tr_clk <= 0;
      tr_data <= 0;
    end else begin
      x2 <= x1;
      tr_clk <= ~phase;  // tr_clk is now a valid l-value
      if (phase) begin
        tr_data <= tw[17:0];
      end else begin
        tr_data <= tw[35:18];
      end
    end
  end

endmodule