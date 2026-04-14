module top_module(
  input [n-1:0] REQ,
  input CLK,
  input RST,
  output GRANT
);parameter n = 4; // number of request signals

reg [n-1:0] req_priority;
reg [n-1:0] req_grant;

always @ (posedge CLK) begin
  if (RST) begin
    req_priority <= 0;
    req_grant <= 0;
  end else begin
    // Determine highest priority request
    req_priority <= {req_priority[n-2:0], req_priority[n-1]};
    if (REQ != 0) begin
      req_priority[0] <= REQ & ~req_grant;
    end
    // Grant access to highest priority request
    req_grant <= req_priority[0];
  end
end

assign GRANT = req_grant;

endmodule