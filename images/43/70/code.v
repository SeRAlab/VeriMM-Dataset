module top_module(
    input i_clk,
    input i_reset,
    input i_start,
    input [7:0] i_duration,
    output reg o_pulse
);reg [7:0] count;

    always @(posedge i_clk or posedge i_reset) begin
        if (i_reset) begin
            count <= 0;
            o_pulse <= 0;
        end else if (i_start) begin
            count <= i_duration;
            o_pulse <= 1;
        end else if (count > 0) begin
            count <= count - 1;
            o_pulse <= 1;
        end else begin
            o_pulse <= 0;
        end
    end

endmodule