module pll_8x (
    input wire clk_in,        // Input clock
    input wire rst,          // Reset signal
    output reg clk_out       // Output clock (8x frequency)
);
    reg [2:0] counter;
    
    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            clk_out <= 1'b0;
        end else begin
            if (counter == 3'b111) begin  // Count to 8
                clk_out <= ~clk_out;      // Toggle output clock
                counter <= 3'b000;         // Reset counter
            end else begin
                counter <= counter + 1'b1; // Increment counter
            end
        end
    end
endmodule