module watchdog_timer (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg timeout
);
    parameter TIMEOUT_VALUE = 10;
    reg [3:0] count; // 4-bit counter to count up to 10
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            timeout <= 0;
        end else if (enable) begin
            if (count < TIMEOUT_VALUE - 1) begin
                count <= count + 1;
                timeout <= 0;
            end else begin
                timeout <= 1; // Timeout occurred
            end
        end
    end
endmodule