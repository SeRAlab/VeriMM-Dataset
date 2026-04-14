module top_module(
  input [n-1:0] req,
  output [m-1:0] access
);parameter n = 4; // number of memory requests
parameter m = 1; // number of memory access signals

reg [n-1:0] req_priority; // priority scheme based on requests
reg [n-1:0] access_granted; // memory access signals

always @(*) begin
  // Priority scheme based on requests
  casez(req)
    4'b0001: req_priority = 4'b0001; // Request 1 has highest priority
    4'b0010: req_priority = 4'b0010; // Request 2 has highest priority
    4'b0100: req_priority = 4'b0100; // Request 3 has highest priority
    4'b1000: req_priority = 4'b1000; // Request 4 has highest priority
    default: req_priority = 4'b0000; // No requests
  endcase

  // Grant access to one memory request at a time
  casez(req_priority & ~access_granted)
    4'b0001: access_granted = 4'b0001; // Grant access to Request 1
    4'b0010: access_granted = 4'b0010; // Grant access to Request 2
    4'b0100: access_granted = 4'b0100; // Grant access to Request 3
    4'b1000: access_granted = 4'b1000; // Grant access to Request 4
    default: access_granted = 4'b0000; // No access granted
  endcase
end

assign access = access_granted; // Connect memory access signals to granted access

endmodule