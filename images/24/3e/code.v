module watchdog_timer(
    input wire clk,
    input wire reset,
    input wire kick,
    output reg [3:0] counter,
    output reg timeout
);
    parameter TIMEOUT_PERIOD = 8; // Adjust the timeout period as needed
    reg [3:0] timeout_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            timeout <= 1'b0;
            timeout_counter <= 4'b0000;
        end else begin
            if (kick) begin
                if (timeout_counter < TIMEOUT_PERIOD - 1) begin
                    timeout_counter <= timeout_counter + 1;
                    counter <= counter + 1;
                    timeout <= 1'b0;
                end else begin
                    timeout <= 1'b1;
                    counter <= 4'b0000; // Reset counter if timeout occurs
                end
            end else begin
                if (timeout_counter < TIMEOUT_PERIOD) begin
                    timeout_counter <= timeout_counter + 1;
                end else begin
                    timeout <= 1'b1; // Set timeout flag
                    counter <= 4'b0000; // Reset counter
                end
            end
        end
    end
endmodule