module watchdog_timer(
    input wire clk,
    input wire reset,
    input wire timeout,
    output reg timer_expired
);
    reg [3:0] count; // 4-bit counter for 10 clock cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            timer_expired <= 0;
        end else if (timeout) begin
            count <= 0;
            timer_expired <= 0;
        end else if (count < 10) begin
            count <= count + 1;
            timer_expired <= 0;
        end else begin
            timer_expired <= 1;
        end
    end
endmodule