module vco (
    input clk,           // Clock input
    input [2:0] ctrl,   // Control voltage (3-bit representation of 0-7)
    output reg out       // Output square wave
);
    reg [23:0] counter;  // 24-bit counter for frequency division
    parameter MAX_COUNT = 24'd1000000; // Max count for 1 MHz

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= (MAX_COUNT >> ctrl)) begin
            out <= ~out; // Toggle output
            counter <= 0; // Reset counter
        end
    end
endmodule