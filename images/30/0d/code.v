module rc_oscillator (
    input clk,
    output reg oscillate
);
    reg [3:0] counter; // 4-bit counter to count clock cycles (up to 15)

    always @(posedge clk) begin
        if (counter == 10) begin
            oscillate <= ~oscillate; // Toggle output
            counter <= 0; // Reset counter
        end else begin
            counter <= counter + 1; // Increment counter
        end
    end

    initial begin
        oscillate = 0; // Initialize oscillate value
        counter = 0; // Initialize counter
    end
endmodule