module timer(
    input wire clk,            // Clock input
    input wire reset,          // Reset input
    input wire enable,         // Enable input
    output reg [15:0] count,   // 16-bit counter output
    output reg overflow        // Overflow output
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;     // Reset count to 0
            overflow <= 1'b0;   // Clear overflow indicator
        end else if (enable) begin
            if (count == 16'hFFFF) begin
                count <= 16'b0; // Roll over to 0
                overflow <= 1'b1; // Set overflow flag
            end else begin
                count <= count + 1; // Increment count
                overflow <= 1'b0;     // Clear overflow flag
            end
        end
    end
endmodule