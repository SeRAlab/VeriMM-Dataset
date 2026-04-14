module counter_3bit (clk, clr, en, q);
   input clk, clr, en;
   output [2:0] q;

   reg [2:0] q;

always @(posedge clk or posedge clr) begin
    if (clr) begin
        q <= 3'b000;
    end else if (en) begin
        q <= q + 1;
    end
end

endmodule