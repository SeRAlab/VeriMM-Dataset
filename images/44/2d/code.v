module top_module(
    input AC,
    input CLK,
    output reg DC
);reg diode_output;

    // Create a clock signal that is high during the positive half of the AC waveform
    always @(posedge CLK) begin
        if (AC > 0) begin
            diode_output <= AC; // Capture the positive part of AC
        end else begin
            diode_output <= 0; // Zero output for negative AC
        end
    end

    // Output the rectified DC voltage
    always @(posedge CLK) begin
        DC <= diode_output; // Update DC based on diode output
    end

endmodule