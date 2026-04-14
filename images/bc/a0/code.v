module top_module(
    input clk,
    input rst,
    input en,
    input [31:0] width,
    output reg [31:0] count
);always @(posedge clk) begin
    if (rst) begin
        count <= 0;
    end else if (en) begin
        if (count == (2**width)-1) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end
end

endmodule