module rc_oscillator(
    input clk,
    input reset,
    output reg out
);
    reg [23:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 0;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 24'd5000000) begin // example for a toggle frequency
                out <= ~out; // toggle output
                counter <= 0; // reset counter
            end
        end
    end
endmodule