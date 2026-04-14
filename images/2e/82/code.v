module gpio_controller (
    input wire clk,
    input wire ctrl,     // Control signal: 1 for write, 0 for read
    input wire din,      // Data input for writing to GPIO pin
    output reg dout,     // Data output reading from GPIO pin
    input wire pin_state // Current state of the GPIO pin
);
    
    always @(posedge clk) begin
        if (ctrl) begin
            dout <= din; // Write operation
        end else begin
            dout <= pin_state; // Read operation
        end
    end

endmodule