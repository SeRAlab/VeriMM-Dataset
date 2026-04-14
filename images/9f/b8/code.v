module top_module(
    input clk,
    input rst,
    output reg [2:0] count
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        count <= 3'b0;
    end else begin
        count <= count + 1;
    end
end

endmodule