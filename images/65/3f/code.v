module top_module(
    input clk_1hz,
    output reg [3:0] hours,
    output reg [3:0] minutes,
    output reg [3:0] seconds
);reg [25:0] count = 0; // 26 bits for counting up to 86400 (24 hours in seconds)

always @(posedge clk_1hz) begin
    count <= count + 1;
    if (count == 86400) // reset after 24 hours
        count <= 0;
end

always @(posedge clk_1hz) begin
    if (count % 60 == 0) begin // increment seconds
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 23)
                    hours <= 0;
                else
                    hours <= hours + 1;
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

endmodule