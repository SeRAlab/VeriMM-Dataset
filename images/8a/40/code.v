module prbs_generator (
  input clk,
  input en,
  output reg [7:0] prbs);

always @(posedge clk) begin
    if (en)
        prbs <= {prbs[6:0], prbs[7] ^ prbs[4] ^ prbs[3] ^ prbs[2]};
end
endmodule