module d_ff_async_reset (clk, rst, d, q);
   input clk, rst, d;
   output q;

   reg q;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule