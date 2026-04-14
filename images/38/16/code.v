module watchdog_timer #(parameter THRESHOLD = 10) (
    input wire clk,
    input wire enable,
    input wire reset,
    output reg timeout
);
    reg [3:0] counter; // 4-bit counter to count clock cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            timeout <= 0;
        end else if (enable) begin
            if (counter < THRESHOLD) begin
                counter <= counter + 1;
            end else begin
                timeout <= 1; // Trigger timeout
            end
        end
    end
endmodule