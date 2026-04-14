module top_module(
    input clk,
    input rst,
    input pulse,
    output reg [31:0] count
);always @(posedge clk or negedge rst) begin
    if (!rst) begin
        count <= 0;
    end else if (pulse) begin
        count <= count + 1;
    end
end

endmodule