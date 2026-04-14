module watchdog_timer(
    input wire clk,
    input wire reset_n, // Active low reset
    input wire pet,     // Signal to reset the timer
    output reg reset    // Reset signal
);
    reg [2:0] count; // 3-bit counter for 5 clock cycles

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 3'b000; // Reset counter on reset
            reset <= 1'b0;   // Reset signal low
        end else if (pet) begin
            count <= 3'b000; // Reset counter if pet signal is received
            reset <= 1'b0;   // Keep reset signal low
        end else if (count < 3'b101) begin
            count <= count + 1; // Increment counter
            reset <= 1'b0;       // Keep reset signal low
        end else begin
            reset <= 1'b1;       // Assert reset signal if timeout
        end
    end
endmodule