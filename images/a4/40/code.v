module top_module(input D, C, R, P, output reg Q);always @(posedge C, negedge R, negedge P)
    begin
        if (!R)
            Q <= 0;
        else if (!P)
            Q <= 1;
        else
            Q <= D;
    end

endmodule