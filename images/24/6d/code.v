module RC_Oscillator(
    input wire clk,      // Clock input
    input wire reset,    // Asynchronous reset
    input wire control,  // Control signal to determine the frequency
    output reg out       // Square wave output
);
    reg [23:0] counter;  // 24-bit counter for frequency division

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
            counter <= 0;
        end else begin
            if (counter < (control ? 24'd999999 : 24'd499999)) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                out <= ~out; // Toggle output
            end
        end
    end
endmodule