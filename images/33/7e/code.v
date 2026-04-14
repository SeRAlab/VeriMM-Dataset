module divide_by_2 (
    input clk,
    input rst,
    output reg out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end else begin
            out <= ~out; // Toggle output on each clock cycle
        end
    end
endmodule