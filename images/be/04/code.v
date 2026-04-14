module top_module(
  input [n-1:0] req,
  output [n-1:0] gnt
);parameter n = 4; // number of devices

reg [n-1:0] grant_queue;
reg [n-1:0] round_robin_counter;

always @(*) begin
  // If there are no requests, do not grant access to any device
  if (req == 0) begin
    grant_queue = 0;
  end
  else begin
    // Round-robin algorithm to grant access to requesting devices in a fair manner
    grant_queue[round_robin_counter] = req[round_robin_counter];
    round_robin_counter = round_robin_counter + 1;
    if (round_robin_counter == n) begin
      round_robin_counter = 0;
    end
  end
end

assign gnt = grant_queue & req;

endmodule