module pulse_generator (
    input wire clk,
    input wire reset,
    input wire trigger,
    input wire [3:0] pulse_width, // pulse width in clock cycles
    output reg pulse_out
);
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pulse_out <= 0;
            count <= 0;
        end else begin
            if (trigger) begin
                pulse_out <= 1;
                count <= pulse_width;
            end else if (count > 0) begin
                count <= count - 1;
            end
            
            if (count == 0) begin
                pulse_out <= 0;
            end
        end
    end
endmodule