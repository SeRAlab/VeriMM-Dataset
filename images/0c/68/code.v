module dwt_haar (
    input wire clk,
    input wire reset,
    input wire [3:0] x,
    input wire valid,
    output reg [3:0] a,
    output reg [3:0] d,
    output reg done
);
    reg [3:0] x0, x1;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            a <= 4'b0;
            d <= 4'b0;
            done <= 1'b0;
        end else if (valid) begin
            x0 <= x[3:2];   // Taking the first 2 bits
            x1 <= x[1:0];   // Taking the last 2 bits
            
            // Haar transform calculations
            a <= (x0 + x1) >> 1; // Approximation coefficient
            d <= (x0 - x1);      // Detail coefficient
            
            done <= 1'b1;        // Indicate computation done
        end
    end
endmodule