module state_space_controller (
    input clk,
    input rst,
    input [1:0] x,        // Current state (2 bits)
    input [0:0] u,        // Input (1 bit)
    output reg [1:0] x_next, // Next state (2 bits)
    output reg [0:0] y      // Output (1 bit)
);
    
    // State-space matrices
    wire [1:0] A[0:1]; // A matrix
    wire [1:0] B[0:0]; // B matrix
    wire [0:0] C[0:1]; // C matrix
    wire [0:0] D[0:0]; // D matrix

    assign A[0] = 2'b01; // A[0][0] = 0.5, represent with 2'b01
    assign A[1] = 2'b10; // A[1][0] = 0.1, represent with 2'b10
    assign B[0] = 2'b01; // B[0][0] = 1, represent with 2'b01
    assign C[0] = 2'b01; // C[0][0] = 1, represent with 2'b01
    assign D[0] = 2'b00; // D[0][0] = 0, represent with 2'b00

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_next <= 2'b00; // Reset state
            y <= 1'b0;       // Reset output
        end else begin
            // State transition
            x_next[0] <= A[0][0] * x[0] + A[0][1] * x[1] + B[0][0] * u; // x_next[0]
            x_next[1] <= A[1][0] * x[0] + A[1][1] * x[1];               // x_next[1]

            // Output equation
            y <= C[0][0] * x[0] + D[0][0] * u;
        end
    end
endmodule