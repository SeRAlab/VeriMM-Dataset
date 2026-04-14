module comparator(a, b, lt, eq, gt);
input [7:0] a, b;
output lt, eq, gt;
reg lt, eq, gt;

always@(a or b) begin
    if (a < b) begin
        lt = 1;
        eq = 0;
        gt = 0;
    end
    else if (a == b) begin
        lt = 0;
        eq = 1;
        gt = 0;
    end
    else begin
        lt = 0;
        eq = 0;
        gt = 1;
    end
end

endmodule