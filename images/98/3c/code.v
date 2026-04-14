module top_module(clk, rst, push_req_n, pop_req_n, data_in, data_out);input         clk;
input         rst;
input         push_req_n;
input         pop_req_n;
input  [15:0] data_in;
output [15:0] data_out;

reg [15:0] FIFO[127:0];
reg [ 6:0] wr_ptr;
reg [ 6:0] rd_ptr;

assign  data_out = FIFO[rd_ptr];

always @(posedge clk)
begin
   if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
   end
   else begin
      if (push_req_n == 0) begin
         FIFO[wr_ptr] <= data_in;
         wr_ptr       <= wr_ptr + 1;
      end
      if (pop_req_n == 0) begin
         rd_ptr       <= rd_ptr + 1;
      end
   end
end

endmodule