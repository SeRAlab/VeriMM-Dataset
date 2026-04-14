module top_module(
    input wire clk,
    input wire out,
    input wire in0,
    output reg AS
);always @(posedge clk or negedge in0) begin
        if (!in0) begin
            AS <= 0;
        end else begin
            AS <= out;
        end
    end

endmodule