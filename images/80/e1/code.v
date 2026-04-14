module top_module(
    input [7:0] a,
    input [7:0] b,
    input ctrl,
    output reg [7:0] out
    );always @ (a or b or ctrl)
    begin
        if(ctrl == 0)
            out = a + b;
        else
            out = a - b;
    end
    
endmodule