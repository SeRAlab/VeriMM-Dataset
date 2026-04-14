module divide_by_8 (
    input clk,
    input rst,
    input [2:0] in,
    output reg out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end else begin
            if (in == 3'b000) // Only 0 is divisible by 8 in 3 bits
                out <= 1;
            else
                out <= 0;
        end
    end
endmodule