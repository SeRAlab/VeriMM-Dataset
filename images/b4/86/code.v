module top_module(A, B, ADDSUB, RES);parameter  WIDTH = 8;
    input                   ADDSUB;
    input       [WIDTH-1:0] A;
    input       [WIDTH-1:0] B;
    output reg  [WIDTH-1:0] RES;

    always @(A or B or ADDSUB)
    begin
        if (ADDSUB == 1'b0)
	    RES = A + B;
        else
	    RES = A - B;
    end

endmodule