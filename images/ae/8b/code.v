module top_module(
    input [width-1:0] A,B,
    output reg [width-1:0] Z
    );parameter width = 8;
    always @(A or B)
    begin
        Z = A + B;
    end
endmodule