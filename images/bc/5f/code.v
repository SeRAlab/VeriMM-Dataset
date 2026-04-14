module top_module(
    input clk,
    input sel,
    input [23:0] rgb_0,
    input [23:0] rgb_1,
    output reg [23:0] rgb_out
);always @(posedge clk) begin
    if(sel == 1'b0) begin
        rgb_out <= rgb_0;
    end else begin
        rgb_out <= rgb_1;
    end
end

endmodule