module top_module(
    input clk,
    input preset,
    input [6:0] preset_value,
    input ena,
    output reg [6:0] q);

    always @(posedge clk) begin
        if (preset) begin
            q <= preset_value;
        end else if (ena) begin
            q <= q + 1;
        end
    end

endmodule