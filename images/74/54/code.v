module top_module(
    input x, y, s,
    output reg m
    );always @(x, y, s)
    begin
        case(s)
            0: m = x;
            1: m = y;
        endcase
    end
    
endmodule