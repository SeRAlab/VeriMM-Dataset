module divide_by_2 (
    input clk,
    input rst,
    input in,
    output reg out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        out <= 0;
    else
        out <= in; // Divide-by-2 for 1-bit input is just passing the input through
end

endmodule