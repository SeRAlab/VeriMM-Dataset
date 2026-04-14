module rc_oscillator (
    input wire clk,          // Clock input
    input wire reset,        // Asynchronous reset
    output reg out          // Output of the RC oscillator
);
    reg [3:0] counter;      // 4-bit counter for frequency division

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'd0;
            out <= 1'b0;
        end else begin
            if (counter == 4'd15) begin
                out <= ~out;    // Toggle output
                counter <= 4'd0; // Reset counter
            end else begin
                counter <= counter + 4'd1; // Increment counter
            end
        end
    end
endmodule