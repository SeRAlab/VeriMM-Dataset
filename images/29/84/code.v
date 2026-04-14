module timer (
    input wire clk,
    input wire rst,
    input wire start,
    input wire stop,
    input wire [31:0] countdown_value,
    output reg [31:0] timer_value,
    output reg timer_done
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timer_value <= 32'b0;
            timer_done <= 1'b0;
        end else if (start) begin
            if (timer_value < countdown_value) begin
                timer_value <= timer_value + 1;
                timer_done <= 1'b0;
            end else begin
                timer_done <= 1'b1;
            end
        end else if (stop) begin
            // Do nothing, keep the current timer value
        end
    end
endmodule