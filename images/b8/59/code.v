module top_module(
  input clk,
  input clkx2,
  input jrst_n,
  input [35:0] tw,
  output reg tr_clk,
  output reg [17:0] tr_data
);reg [1:0] x;
  wire phase;

  always @(posedge clk or negedge jrst_n) begin
    if (~jrst_n) begin
      x <= 2'b0; // Update this line to set the entire register
      tr_clk <= 0;
      tr_data <= 0;
    end else begin
      x[0] <= ~x[1];
      x[1] <= x[0];
    end
  end

  assign phase = x[0] ^ x[1]; // Replace the "phase <=" assignment with an assign statement

  always @(posedge clkx2 or negedge jrst_n) begin
    if (~jrst_n) begin
      tr_clk <= 0;
      tr_data <= 0;
    end else begin
      tr_clk <= ~phase;
      tr_data <= phase ? tw[17:0] : tw[35:18];
    end
  end

endmodule