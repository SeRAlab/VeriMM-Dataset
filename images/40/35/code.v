module state_space_controller (
    input clk,
    input reset,
    input u,
    output reg [1:0] y
);
    reg [1:0] x; // State variable, 2-bit wide

    // Define the state-space matrices
    parameter A0 = 1, A1 = 0, A2 = 0, A3 = 1; // A matrix
    parameter B0 = 1, B1 = 1; // B matrix
    parameter C0 = 1, C1 = 0; // C matrix
    parameter D = 0; // D matrix

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 2'b00; // Initial state
        end else begin
            // State update: x_next = Ax + Bu
            x[0] <= A0 * x[0] + B0 * u;
            x[1] <= A3 * x[1] + B1 * u;
        end
    end

    always @(*) begin
        // Output: y = Cx + Du
        y = {C0 * x[0] + D, C1 * x[1]}; 
    end
endmodule