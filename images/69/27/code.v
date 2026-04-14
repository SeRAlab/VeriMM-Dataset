module top_module
(
    input clk,
    input sreset,
    input enable,
    input dir,
    output reg [7:0] count
);always @(posedge clk)
        if (sreset) begin
            count <= 8'b0;
        end else if (enable) begin
            if (dir) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
endmodule