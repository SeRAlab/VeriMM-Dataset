module top_module(
  input wire address,
  input wire clock,
  input wire reset_n,
  output reg [31:0] readdata
);always @(posedge clock) begin
    if (!reset_n) begin
      readdata <= 0;
    end else begin
      readdata <= address ? 1423170505 : 0;
    end
  end

endmodule