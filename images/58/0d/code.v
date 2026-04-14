module top_module(
    input [width-1:0] A,B,
    input S0,
    output reg [width-1:0] Z
    );parameter width = 8;
    always @(A or B or S0)
    begin
        if(S0)
            Z <= B;
        else
            Z <= A;
    end
endmodule