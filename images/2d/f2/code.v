module state_space_controller (
    input clk,
    input reset,
    input [1:0] u,    // Input vector (1 bit)
    output reg [1:0] y // Output vector (1 bit)
);
    reg [1:0] x; // State vector

    // State update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 2'b00; // Initial state
        end else begin
            x[1] <= x[0]; // state[1] = state[0]
            x[0] <= x[0] ^ u; // state[0] = state[0] XOR input
        end
    end

    // Output logic
    always @(*) begin
        y = x; // Output is the state
    end
endmodule