module top_module(
    input clk,
    input rst,
    input [15:0] in_data,
    output reg [15:0] out_data
);always @(posedge clk or negedge rst) begin
    if (!rst) begin
        out_data <= 16'h0000;
    end else begin
        out_data <= in_data + 16'h1234;
    end
end

endmodule