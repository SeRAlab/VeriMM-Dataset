module top_module
(
    input clk,
    input aload,
    input [6:0] load_val,
    output reg [6:0] count
);

always @(posedge clk or posedge aload)
    if (aload) begin
        count <= load_val;
    end else begin
        count <= count - 1;
    end
endmodule