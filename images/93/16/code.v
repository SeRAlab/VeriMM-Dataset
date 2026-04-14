module top_module(
    input clk,
    input rst,
    output reg [3:0] out
);always @(posedge clk or posedge rst)
    begin
        if (rst)
            out <= 4'b0;
        else if (out == 4'hF)
            out <= 4'b0;
        else
            out <= out + 1;
    end

endmodule