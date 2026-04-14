module divide_by_2(
    input wire clk,
    input wire reset,
    output reg out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
        end else begin
            out <= ~out;
        end
    end
endmodule