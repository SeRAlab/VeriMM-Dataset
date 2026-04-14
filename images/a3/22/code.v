module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input wen, // write enable signal
  input ren, // read enable signal
  input [DATA_WIDTH-1:0] din, // data input
  output [DATA_WIDTH-1:0] dout, // data output
  output full, // full signal
  output empty // empty signal
);parameter MAX_DEPTH = 8; // maximum depth of the buffer
parameter DATA_WIDTH = 8; // width of the data items in bits

// Calculate log2 of MAX_DEPTH
function integer log2;
  input integer value;
  begin
    log2 = 0;
    while (2**log2 < value) begin
      log2 = log2 + 1;
    end
  end
endfunction

// internal signals
reg [DATA_WIDTH-1:0] buffer [0:MAX_DEPTH-1];
reg [log2(MAX_DEPTH)-1:0] wr_ptr, rd_ptr;
wire [log2(MAX_DEPTH)-1:0] next_wr_ptr, next_rd_ptr;

// combinational logic to calculate next pointers
assign next_wr_ptr = wen ? ((wr_ptr == MAX_DEPTH-1) ? 0 : wr_ptr+1) : wr_ptr;
assign next_rd_ptr = ren ? ((rd_ptr == MAX_DEPTH-1) ? 0 : rd_ptr+1) : rd_ptr;

// sequential logic for read and write operations
always @(posedge clk) begin
  if (rst) begin
    wr_ptr <= 0;
    rd_ptr <= 0;
  end
  else begin
    wr_ptr <= next_wr_ptr;
    rd_ptr <= next_rd_ptr;
    if (wen && !full) buffer[wr_ptr] <= din; // add full check to avoid overwriting
  end
end

// output logic
assign dout = buffer[rd_ptr];
assign full = (next_wr_ptr == rd_ptr) && (wr_ptr != rd_ptr);
assign empty = (wr_ptr == rd_ptr);

endmodule