module top_module(
  input [n-1:0] req,
  output reg [n-1:0] grant // Changed from wire to reg
);parameter n = 4; // number of request signals
  
  reg [n-1:0] req_priority; // priority of each request
  reg [n-1:0] req_waiting_time; // waiting time of each request
  
  integer i;
  
  always @(*) begin
    // Initialize grant to 0
    grant = 0;
    
    // set priority of each request
    for (i = 0; i < n; i = i + 1) begin
      if (req[i] == 1'b1) begin
        req_priority[i] = i;
      end else begin
        req_priority[i] = n;
      end
    end
    
    // set waiting time of each request
    for (i = 0; i < n; i = i + 1) begin
      if (req[i] == 1'b1) begin
        req_waiting_time[i] = req_waiting_time[i] + 1;
      end else begin
        req_waiting_time[i] = 0;
      end
    end
    
    // select highest priority request
    for (i = 0; i < n; i = i + 1) begin
      if (req[i] == 1'b1) begin
        if (req_priority[i] < req_priority[grant]) begin
          grant = i;
        end else if ((req_priority[i] == req_priority[grant]) && (req_waiting_time[i] > req_waiting_time[grant])) begin
          grant = i;
        end
      end
    end
  end

endmodule