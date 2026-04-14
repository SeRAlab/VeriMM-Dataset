module pulse_generator(
    input wire clk,
    input wire reset,
    input wire [31:0] pulse_width, // in clock cycles
    input wire [31:0] period,       // in clock cycles
    output reg pulse_out
);
    reg [31:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            pulse_out <= 0;
        end else begin
            if (count < period) begin
                if (count < pulse_width) begin
                    pulse_out <= 1; // Generate pulse
                end else begin
                    pulse_out <= 0; // End pulse
                end
                count <= count + 1;
            end else begin
                count <= 0; // Reset count after full period
            end
        end
    end
endmodule