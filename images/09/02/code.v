module crystal_oscillator (
    input wire clk,          // Input clock signal
    input wire rst,          // Active high reset signal
    input wire [3:0] div,    // 4-bit division factor
    output reg out           // Output square wave
);

reg [3:0] count;            // Counter to track the clock cycles

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;         // Reset the counter
        out <= 0;           // Reset output
    end else begin
        if (count == div) begin
            out <= ~out;    // Toggle the output when the count reaches the division value
            count <= 0;     // Reset the counter
        end else begin
            count <= count + 1; // Increment the counter
        end
    end
end
endmodule