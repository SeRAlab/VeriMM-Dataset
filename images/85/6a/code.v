module top_module(
    input clk,
    input rst,
    input en,
    input [3:0] din,
    output reg [3:0] dout
);always @(posedge clk or negedge rst) begin
    if (!rst) begin
        dout <= 4'b0;
    end
    else begin
        if (en) begin
            dout <= din;
        end
    end
end

endmodule