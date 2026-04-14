module watchdog_timer (
    input clk,
    input reset,
    output reg timer_expired
);
    parameter TIMEOUT = 10; // Timeout period in clock cycles
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            timer_expired <= 0;
        end else if (count < TIMEOUT) begin
            count <= count + 1;
            timer_expired <= 0;
        end else begin
            timer_expired <= 1;
        end
    end
endmodule