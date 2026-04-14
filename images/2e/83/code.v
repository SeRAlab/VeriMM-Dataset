module pulse_generator (
    input wire clk,
    input wire enable,
    input wire [3:0] PULSE_WIDTH, // Pulse width in clock cycles
    input wire [3:0] PERIOD,      // Total period in clock cycles
    output reg pulse_out
);
    reg [3:0] count;              // Counter for the current clock cycle
    reg [3:0] pulse_counter;      // Counter for the pulse width

    always @(posedge clk) begin
        if (!enable) begin
            pulse_out <= 0;
            count <= 0;
            pulse_counter <= 0;
        end else begin
            if (count < PERIOD) begin
                count <= count + 1;
                if (pulse_counter < PULSE_WIDTH) begin
                    pulse_out <= 1;
                    pulse_counter <= pulse_counter + 1;
                end else begin
                    pulse_out <= 0;
                end
            end else begin
                count <= 0;
                pulse_counter <= 0;
            end
        end
    end
endmodule