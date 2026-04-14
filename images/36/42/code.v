module divide_by_4 (
    input [1:0] in,
    output reg out
);
    always @(in) begin
        if (in == 2'b00 || in == 2'b01) 
            out = 1'b1;
        else 
            out = 1'b0;
    end
endmodule