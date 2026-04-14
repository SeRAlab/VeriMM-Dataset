module top_module(
    input clk,
    input rst,
    input en,
    input load,
    input [31:0] data_in,
    output reg [31:0] count
);always @(posedge clk or negedge rst) begin
    if (!rst) begin
        count <= 0;
    end else if (load) begin
        count <= data_in;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule