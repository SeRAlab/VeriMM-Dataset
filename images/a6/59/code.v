module top_module(
  input [n-1:0] req,
  input [n-1:0] src,
  output reg grant // Changed grant to reg type
);parameter n = 4; // number of sources

reg [n-1:0] priority_levels; // priority levels for each source
reg [n-1:0] grant_request; // request signals for granted source
reg [$clog2(n)-1:0] grant_source; // source signals for granted source (changed to appropriate width)
reg [$clog2(n)-1:0] grant_priority; // priority levels for granted source
reg [n-1:0] granted; // granted signals for each source
integer i; // Declare i as an integer

// initialize priority levels
initial begin
  priority_levels[0] = 3; // highest priority for source 0
  priority_levels[1] = 2; // medium priority for source 1
  priority_levels[2] = 1; // low priority for source 2
  priority_levels[3] = 0; // lowest priority for source 3
end

// determine highest priority request
always @* begin
  grant_request = 0;
  grant_source = 0;
  grant_priority = 0;

  for (i = 0; i < n; i = i + 1) begin
    if (req[i] && priority_levels[i] > grant_priority[grant_source]) begin
      grant_request = req[i];
      grant_source = src[i];
      grant_priority[grant_source] = priority_levels[i];
    end
  end
end

// grant access to highest priority request
always @* begin
  granted = 0;

  if (grant_request != 0) begin
    granted[grant_source] = 1;
  end

  grant = granted; // This is okay since grant is now declared as reg
end

endmodule