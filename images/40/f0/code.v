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
        end else if (trigger) begin
            if (count < pulse_width) begin
                pulse_out <= 1;
                count <= count + 1;
            end else begin
                pulse_out <= 0;
            end
        end else begin
            pulse_out <= 0;
            count <= 0;
        end
    end
endmodule