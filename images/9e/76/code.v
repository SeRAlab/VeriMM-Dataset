module top_module(
    input clk,
    input reset,
    input data,
    input [3:0] time_window,
    output reg rise,
    output reg fall
);reg [3:0] count_r;
reg [3:0] count_f;
reg [3:0] delay;

always @(posedge clk) begin
    if (reset) begin
        count_r <= 0;
        count_f <= 0;
        delay <= time_window;
        rise <= 0;
        fall <= 0;
    end else begin
        if (data && !delay) begin
            count_r <= count_r + 1;
            count_f <= 0;
            if (count_r == 1) begin
                rise <= 1;
            end else begin
                rise <= 0;
            end
        end else if (!data && !delay) begin
            count_f <= count_f + 1;
            count_r <= 0;
            if (count_f == 1) begin
                fall <= 1;
            end else begin
                fall <= 0;
            end
        end else begin
            count_r <= 0;
            count_f <= 0;
            rise <= 0;
            fall <= 0;
        end
        if (delay > 0) begin
            delay <= delay - 1;
        end
    end
end

endmodule