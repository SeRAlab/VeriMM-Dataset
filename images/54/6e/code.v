module top_module(
    input x,
    input y,
    input s,
    output reg m
    );always @ (x or y or s)
    begin
        if (s == 0)
            m = x;
        else
            m = y;
    end
endmodule