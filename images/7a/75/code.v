module top_module(
    input clk,
    input rst,
    input enable,
    input [15:0] freq,
    output reg pulse
);reg [15:0] count;
reg [15:0] threshold;

always @(posedge clk) begin
    if (rst) begin
        count <= 0;
        threshold <= 0;
        pulse <= 0;
    end else if (enable) begin
        count <= count + 1;
        if (count == threshold) begin
            pulse <= ~pulse;
            threshold <= freq - 1;
        end
    end
end

endmodule