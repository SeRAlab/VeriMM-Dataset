module top_module (
    input clk,
    input [3:0] in,
    output reg [2:0] count
);
    always @(posedge clk) begin
        count <= in[0] + in[1] + in[2] + in[3];
    end
endmodule