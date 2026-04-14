module top_module(
  input [n-1:0] mem_req,
  input [n-1:0] mem_ack,
  output reg [n-1:0] mem_req_out,  // Renamed output to mem_req_out
  output reg [n-1:0] mem_ack_out   // Renamed output to mem_ack_out
);parameter n = 4; // number of memory modules

reg [n-1:0] req_priority; // priority scheme
reg [n-1:0] mem_req_local;  // Local variable to hold selected memory request

always @(*) begin
  // set priority based on predefined scheme
  req_priority = {mem_req[0] & mem_ack[0], mem_req[1] & mem_ack[1], mem_req[2] & mem_ack[2], mem_req[3] & mem_ack[3]};
  
  // select highest priority request
  case(req_priority)
    4'b1000: mem_req_local = mem_req[0]; // Changed to use input mem_req
    4'b0100: mem_req_local = mem_req[1]; // Changed to use input mem_req
    4'b0010: mem_req_local = mem_req[2]; // Changed to use input mem_req
    4'b0001: mem_req_local = mem_req[3]; // Changed to use input mem_req
    default: mem_req_local = 0;
  endcase
  
  // notify memory controller when request has been processed
  mem_ack_out = 0; // output variable initialized
  case(mem_req_local) // Changed to use local mem_req_local
    mem_req[0]: mem_ack_out = mem_ack[0]; // Changed to use input mem_ack
    mem_req[1]: mem_ack_out = mem_ack[1]; // Changed to use input mem_ack
    mem_req[2]: mem_ack_out = mem_ack[2]; // Changed to use input mem_ack
    mem_req[3]: mem_ack_out = mem_ack[3]; // Changed to use input mem_ack
    default: mem_ack_out = 0;
  endcase
end

endmodule