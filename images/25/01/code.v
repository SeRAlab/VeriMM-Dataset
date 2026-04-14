module state_space_controller (  
    input clk,  
    input reset,  
    input [15:0] u, // 1 input  
    output reg [15:0] y // 1 output  
);  
    // State vectors  
    reg [15:0] x1, x2; // Two state variables  
    reg [15:0] A11 = 16'h0001;  
    reg [15:0] A12 = 16'h0002;  
    reg [15:0] A21 = 16'h0003;  
    reg [15:0] A22 = 16'h0004;  
    reg [15:0] B1 = 16'h0005;  
    reg [15:0] B2 = 16'h0006;  
    reg [15:0] C1 = 16'h0007;  
    reg [15:0] D1 = 16'h0008;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x1 <= 16'h0000;  
            x2 <= 16'h0000;  
            y <= 16'h0000;  
        end else begin  
            // State update equations  
            x1 <= A11 * x1 + A12 * x2 + B1 * u;  
            x2 <= A21 * x1 + A22 * x2 + B2 * u;  
            // Output equation  
            y <= C1 * x1 + D1 * u;  
        end  
    end  
endmodule