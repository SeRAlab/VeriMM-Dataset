module top_module(
  input clk,
  input rst,
  input [n-1:0] req,
  input [n-1:0] ack,
  output [n-1:0] mem_req,
  output [n-1:0] mem_ack
);parameter n = 4; // number of requestors

reg [n-1:0] req_priority; // priority of requestors
reg [n-1:0] granted; // granted requestor
reg [n-1:0] mem_req_reg; // memory request register

always @(posedge clk) begin
  if (rst) begin
    req_priority <= 0;
    granted <= 0;
    mem_req_reg <= 0;
  end else begin
    // update request priority
    req_priority <= req_priority + req;
    
    // check if any requestor is granted
    if (granted == 0) begin
      // grant access to highest priority requestor
      granted <= req_priority & ~mem_req_reg;
    end
    
    // update memory request register
    mem_req_reg <= granted;
    
    // check if memory access is completed
    if (ack & mem_req_reg != 0) begin
      // deassert memory request signal
      mem_req_reg <= 0;
      
      // reset granted requestor
      granted <= 0;
    end
  end
end

assign mem_req = mem_req_reg;
assign mem_ack = granted & ack;

endmodule