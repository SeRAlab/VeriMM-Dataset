module top_module(
  input wire address,
  input wire clock,
  input wire reset_n,
  output reg [31:0] readdata
);always @(posedge clock or negedge reset_n) begin
  if (!reset_n) begin
    readdata <= 0;
  end else begin
    case (address)
      1'b0: readdata <= 32'h560F6F0F;
      1'b1: readdata <= 32'hADC3C2C2;
      default: readdata <= 32'h0;
    endcase
  end
end

endmodule