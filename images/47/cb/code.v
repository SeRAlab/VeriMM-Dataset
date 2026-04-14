module top_module(
	clk,rst,
	wdata,wcare,wused,wena,
	lookup_data,match
);parameter DATA_WIDTH = 32;

input clk,rst;
input [DATA_WIDTH-1:0] wdata, wcare;
input wused,wena;

input [DATA_WIDTH-1:0] lookup_data;
output match;
reg match;

reg cell_used;


reg [DATA_WIDTH - 1 : 0] data;
reg [DATA_WIDTH - 1 : 0] care;
always @(posedge clk) begin
  if (rst) begin
	cell_used <= 1'b0;
	data <= {DATA_WIDTH{1'b0}};
	care <= {DATA_WIDTH{1'b0}};
  end else begin
	if (wena) begin
	   cell_used <= wused;
	   data <= wdata;
       care <= wcare;
	end
  end
end


wire [DATA_WIDTH-1:0] bit_match;
genvar i;
generate 
  for (i=0; i<DATA_WIDTH; i=i+1)
  begin : bmt
    assign bit_match[i] = !care[i] | !(data[i] ^ lookup_data[i]);
  end
endgenerate

reg [4:0] encode_out;

integer j,k;
always @(negedge clk) begin
    j = 0;
    for (k=0; k < DATA_WIDTH; k=k+1)
        if (bit_match[k] == 1'b1)
            j = k;
    encode_out  = j;
    
end

always @(posedge clk) begin
  if (rst) match <= 1'b0;
  else match <= (& bit_match) & cell_used;
end

endmodule