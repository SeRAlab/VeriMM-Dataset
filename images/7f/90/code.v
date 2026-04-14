module top_module(
    input clk,
    input reset,
    input [7:0] snoopa,
    input [7:0] snoopd,
    input snoopp,
    output reg snoopq,
    output reg snoopm
);reg [7:0] prgram [0:255];

integer i;

always @(posedge clk) begin
    if (reset) begin
        snoopq <= 0;
        snoopm <= 0;
    end else begin
        snoopq <= prgram[snoopa];
        if (snoopp) begin
            prgram[snoopa] <= snoopd;
        end
    end
end

always @(posedge clk) begin
    if (i == 255) begin
        snoopm <= 1;
        i <= 0;
    end else begin
        i <= i + 1;
    end
end

endmodule