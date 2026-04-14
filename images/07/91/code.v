module state_space_controller (
    input clk,
    input rst,
    input [3:0] u,           // Input
    output reg [3:0] y       // Output
);
    // State and input matrices
    reg [3:0] x;             // State variable
    reg [3:0] A = 4'b1100;   // Example A matrix
    reg [3:0] B = 4'b0011;   // Example B matrix
    reg [3:0] C = 4'b0101;   // Example C matrix
    reg [3:0] D = 4'b0001;   // Example D matrix

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 4'b0000;    // Reset state
            y <= 4'b0000;    // Reset output
        end else begin
            // State update: x[n+1] = Ax[n] + Bu[n]
            x <= (A & x) + (B & u);
            // Output generation: y[n] = Cx[n] + Du[n]
            y <= (C & x) + (D & u);
        end
    end
endmodule