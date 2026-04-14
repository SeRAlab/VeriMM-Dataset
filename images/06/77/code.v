module rc_oscillator(
    input wire clk,           // External clock input
    input wire reset,         // Asynchronous reset
    input wire [3:0] freq,    // Frequency control value
    output reg out            // Output square wave
);
    reg [15:0] count; // Counter for the oscillator

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            out <= 0;
        end else begin
            if (count >= (freq << 1)) begin // Toggle at half period
                out <= ~out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule