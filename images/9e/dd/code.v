module top_module(
  input mem_rd,
  input mem_wr,
  input [n-1:0] req,
  output grant
);parameter n = 4; // number of requesters

reg [n-1:0] round_robin_counter;
wire [n-1:0] priority_encoder;
wire grant_valid;

assign priority_encoder = ~req & {n{mem_rd}} | ~req & {n{mem_wr}};
assign grant_valid = |priority_encoder;

always @ (posedge mem_rd or posedge mem_wr) begin
  if (mem_wr) begin
    round_robin_counter <= 0;
  end else if (grant_valid) begin
    round_robin_counter <= round_robin_counter + 1;
  end
end

assign grant = priority_encoder[round_robin_counter];

endmodule