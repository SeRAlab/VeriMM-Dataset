module watchdog_timer (
    input wire clk,
    input wire rst,
    input wire kick,
    input wire [3:0] timeout, // 4-bit value for timeout in clock cycles
    output reg timeout_out
);
    reg [3:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            timeout_out <= 0;
        end else if (kick) begin
            counter <= 0; // Reset counter on kick
            timeout_out <= 0; // Reset timeout output
        end else begin
            if (counter < timeout) begin
                counter <= counter + 1;
            end else begin
                timeout_out <= 1; // Set timeout signal
            end
        end
    end
endmodule