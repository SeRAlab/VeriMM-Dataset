module digital_clock(
    input clk,
    input reset,
    output reg [4:0] hours,
    output reg [5:0] minutes,
    output reg [5:0] seconds);always @(posedge clk) begin
    if (reset) begin
        hours <= 5'd0;
        minutes <= 6'd0;
        seconds <= 6'd0;
    end else begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 5'd23)
                    hours <= 5'd0;
                else
                    hours <= hours + 1;
            end else
                minutes <= minutes + 1;
        end else
            seconds <= seconds + 1;
    end
end
endmodule