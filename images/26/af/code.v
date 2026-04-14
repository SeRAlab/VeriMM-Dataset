module rc_oscillator (
    input wire clk,          // clock input
    input wire reset,        // reset input
    output reg out_signal    // output square wave signal
);
    parameter MAX_COUNT = 10; // adjustable parameter for frequency
    reg [3:0] counter;         // 4-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            out_signal <= 0;
        end else begin
            if (counter < MAX_COUNT) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                out_signal <= ~out_signal; // toggle output
            end
        end
    end
endmodule