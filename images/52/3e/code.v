module comparator_4bit(a, b, lt, eq, gt);

    input [3:0] a, b;
    output reg lt, eq, gt;

    always @(*)
        begin
            if (a < b)
                begin
                    lt = 1;
                    eq = 0;
                    gt = 0;
                end
            else if (a == b)
                begin
                    lt = 0;
                    eq = 1;
                    gt = 0;
                end
            else
                begin
                    lt = 0;
                    eq = 0;
                    gt = 1;
                end
        end

endmodule