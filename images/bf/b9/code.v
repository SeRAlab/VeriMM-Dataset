module meta_sync_single(
  out,
  clk, reset_n, in
  );
parameter EDGE_DETECT = 0;
input   clk;
input   reset_n;
input   in;
output  out;
reg     out;
generate
    if (EDGE_DETECT) begin
      reg   meta;
      reg   edg1;
      reg   edg2;
        always @(posedge clk or negedge reset_n) begin
            if (reset_n == 1'b0) begin
                meta <= 1'b0;
                edg1 <= 1'b0;
                edg2 <= 1'b0;
                out <= 1'b0;
            end
            else begin
                meta <= in;
                edg1 <= meta;
                edg2 <= edg1;
                out <= edg1 ^ edg2;
            end
        end
    end
    else begin
      reg   meta;
        always @(posedge clk or negedge reset_n) begin
            if (reset_n == 1'b0) begin
                meta <= 1'b0;
                out <= 1'b0;
            end
            else begin
                meta <= in;
                out <= meta;
            end
        end
    end
endgenerate
endmodule