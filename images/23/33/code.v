module pll_8x (
    input wire clk_ref,      // Reference clock input
    input wire reset,        // Asynchronous reset
    output reg clk_out       // Output clock
);
    reg [2:0] counter;       // 3-bit counter for 8x division

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            counter <= 3'b0;
            clk_out <= 1'b0;
        end else begin
            if (counter == 3'b111) begin // Counter reaches 7
                clk_out <= ~clk_out;     // Toggle clock output
                counter <= 3'b0;          // Reset counter
            end else begin
                counter <= counter + 1;   // Increment counter
            end
        end
    end
endmodule