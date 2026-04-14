module pulse_generator (
    input wire clk,
    input wire reset,
    input wire trigger,
    output reg pulse_out
);
    reg [2:0] count; // 3-bit counter to count 5 clock cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse_out <= 0;
            count <= 0;
        end else if (trigger) begin
            count <= 0; // reset the counter
            pulse_out <= 1; // start the pulse
        end else if (count < 5) begin
            count <= count + 1; // increment the counter
        end else begin
            pulse_out <= 0; // end the pulse after 5 cycles
        end
    end
endmodule