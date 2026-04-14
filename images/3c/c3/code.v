module divide_by_2(
    input clk,
    input rst,
    input in,
    output reg out
);
    always @(posedge clk or posedge rst)
    begin
        if (rst)
            out <= 0;
        else
            out <= in >> 1; // Divide by 2 by shifting right
    end
endmodule