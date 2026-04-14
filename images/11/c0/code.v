module mux_with_hazard_detection (
    input wire [2:0] data_in,  // 3 inputs
    input wire [1:0] sel,       // 2-bit select signal
    output wire y               // output
);
    wire y0, y1, y2;

    // Generate outputs for each select case
    assign y0 = (sel == 2'b00) ? data_in[0] : 1'b0;
    assign y1 = (sel == 2'b01) ? data_in[1] : 1'b0;
    assign y2 = (sel == 2'b10) ? data_in[2] : 1'b0;

    // Combine outputs with hazard resolution
    assign y = y0 | y1 | y2;

endmodule