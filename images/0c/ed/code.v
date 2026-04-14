module backpropagation (
    input clk,
    input rst,
    input [1:0] x,          // 2-bit input for two features
    input [1:0] target,     // 2-bit target output
    output reg [1:0] y,     // 2-bit actual output
    output reg done         // Signal when done with training
);
    reg [1:0] w;            // 2-bit weights
    reg [1:0] error;        // 2-bit error
    integer i;              // iteration counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w <= 2'b01;     // Initialize weights
            y <= 2'b00;     // Initialize output
            done <= 0;      // Reset done signal
            i <= 0;         // Initialize iteration counter
        end else if (i < 10) begin // Training for 10 iterations
            y <= (x * w);   // Calculate output
            error <= target - y; // Calculate error
            w <= w + (error >> 1); // Update weights
            i <= i + 1;     // Increment iteration
        end else begin
            done <= 1;      // Set done signal
        end
    end
endmodule