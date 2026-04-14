module comparator_4bit (a, b, gt, lt, eq);
   input [3:0] a;
   input [3:0] b;
   output gt;
   output lt;
   output eq;
   
   reg gt;
   reg lt;
   reg eq;

always @(*) begin
    if (a > b) begin
        gt = 1;
        lt = 0;
        eq = 0;
    end else if (a < b) begin
        gt = 0;
        lt = 1;
        eq = 0;
    end else begin
        gt = 0;
        lt = 0;
        eq = 1;
    end
end

endmodule