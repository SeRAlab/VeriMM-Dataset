module watchdog_timer(
    input wire clk,
    input wire rst,
    input wire[3:0] timeout,
    output reg timeout_signal
);
    reg[3:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            timeout_signal <= 0;
        end else begin
            if (counter < timeout) begin
                counter <= counter + 1;
                timeout_signal <= 0;
            end else begin
                timeout_signal <= 1;
            end
        end
    end
endmodule