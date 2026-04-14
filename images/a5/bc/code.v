module top_module
(
    input clk,
    input en,
    input up_down,
    output reg [3:0] count
);

always @(posedge clk)
    if (en) begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
endmodule