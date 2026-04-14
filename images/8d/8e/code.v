module comparator(a, b, eq, gt, lt);

    input  [3:0] a;  
    input  [3:0] b;  
    output eq;  
    output gt;  
    output lt;  
    reg    eq;  
    reg    gt;  
    reg    lt;

    always @(*)
        begin
            if (a == b)
                begin
                    eq = 1;
                    gt = 0;
                    lt = 0;
                end
            else if (a > b)
                begin
                    eq = 0;
                    gt = 1;
                    lt = 0;
                end
            else
                begin
                    eq = 0;
                    gt = 0;
                    lt = 1;
                end
        end

endmodule