module top_module
(
    input clk,
    input areset,
    input enable,
    input dir,
    output reg [11:0] count
);always @(posedge clk or posedge areset)
        if (areset) begin
            count <= 12'b0;
        end else if (enable) begin
            if (dir) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
endmodule