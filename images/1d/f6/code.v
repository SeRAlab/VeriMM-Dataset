module divide_by_2 (
    input clk,
    input rst,
    input in,
    output reg out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 1'b0;
        end else begin
            out <= in; // In a divide-by-2, the output will be the same as the input for a single bit
        end
    end
endmodule