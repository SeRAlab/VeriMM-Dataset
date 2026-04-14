module top_module(
  input [n-1:0] req,
  input [n-1:0] pri,
  output reg [n-1:0] grant // Changed 'grant' to be a reg type
);parameter n = 4; // number of sources

reg [n-1:0] id;
integer i;
reg [n-1:0] req_valid;
reg [n-1:0] pri_valid;

always @(*) begin
  req_valid = 0; // Initialize req_valid
  pri_valid = 0; // Initialize pri_valid
  for (i = 0; i < n; i = i + 1) begin
    if (req[i]) begin
      req_valid[i] = 1;
      pri_valid[i] = pri[i];
    end 
  end

  if (|req_valid) begin
    id = $onehot0(req_valid);
    if ($countones(id) > 1) begin
      id = $onehot0(pri_valid);
    end
    grant = req & id;
  end else begin
    grant = 0;
  end
end

endmodule