module pulse_generator(
    input wire clk,
    input wire enable,
    input wire [3:0] pulse_width, // in clock cycles
    input wire [3:0] frequency,    // in clock cycles
    output reg pulse_out
);
    reg [3:0] count;
    reg [3:0] pulse_count;
    
    always @(posedge clk) begin
        if (enable) begin
            if (count < frequency) begin
                count <= count + 1;
            end else begin
                count <= 0;
                if (pulse_count < pulse_width) begin
                    pulse_out <= 1;
                    pulse_count <= pulse_count + 1;
                end else begin
                    pulse_out <= 0;
                    pulse_count <= 0;
                end
            end
        end else begin
            count <= 0;
            pulse_out <= 0;
            pulse_count <= 0;
        end
    end
endmodule