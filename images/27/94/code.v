module vco (
    input clk,            // 100 Hz clock input
    input [3:0] ctrl,    // 4-bit control input
    output reg out       // Output square wave
);
    reg [6:0] count;      // 7-bit counter for frequency division
    reg [3:0] target;     // Target count based on control input

    always @(posedge clk) begin
        target <= (1 << ctrl); // Calculate target based on control input
        if (count >= target) begin
            out <= ~out;       // Toggle output when count reaches target
            count <= 0;       // Reset count
        end else begin
            count <= count + 1; // Increment count
        end
    end
endmodule