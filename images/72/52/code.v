module top_module
(
    input clk,
    input sload,
    input [7:0] load_val,
    output reg [7:0] count
);

always @(posedge clk)
    if (sload) begin
        count <= load_val;
    end else begin
        count <= count - 1;
    end
endmodule