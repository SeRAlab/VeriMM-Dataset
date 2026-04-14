module top_module(
  input [n-1:0] req,
  input [m-1:0] pri,
  output reg sel
);parameter n = 4; // number of memory requests 
parameter m = 4; // number of priority inputs

integer i; // Declare the loop counter 'i'
reg [n-1:0] valid_req;
reg [n-1:0] valid_index;
reg [m-1:0] max_pri;
reg [n-1:0] max_index;

always @(*) begin
  max_pri = 'b0;
  max_index = 'b0;
  valid_req = 'b0;

  for (i = 0; i < n; i = i + 1) begin
    if (req[i] && pri[i] > max_pri[0]) begin
      max_pri = {pri[i], 1'b0}; // store the priority
      max_index = i;           // store the index
    end else if (req[i] && pri[i] == max_pri[0] && i < max_index) begin
      max_index = i; // update the index if priority is equal and index is smaller
    end
  end

  valid_req = req & (pri == max_pri[0]);
  valid_index = {valid_req, valid_req}; // Assuming valid_index is meant to store valid requests' indexes
end

// sel assignment logic corrected
assign sel = (valid_req & (1 << max_index)); // Select based on max_index

endmodule