module top_module(
    input XTAL,
    input CS, OE,
    input CLK,
    input DATA_IN,
    input STROBE,
    output reg TP,
    output reg [7:0] DATA_OUT // Open drain (is this important ?)
);parameter TIME_REG = 48'h892424113000; // Should be 1989/03/24 11:30:00

    reg [3:0] COMMAND_SR;
    reg [51:0] TIME_SR;
    wire CLKG, STROBEG; // Gated by CS

    assign CLKG = CS & CLK;
    assign STROBEG = CS & STROBE;

    initial TP = 1'b0;

    // DEBUG
    always #5000 TP = !TP; // 10ms to make startup test quicker - Should be 1Hz -> 500000ns half period

    always @(posedge CLKG) begin
        if (CS) begin
            $display("RTC clocked in data bit '%B'", DATA_IN); // DEBUG
            COMMAND_SR[2:0] <= COMMAND_SR[3:1];
            COMMAND_SR[3] <= DATA_IN;
        end
    end

    always @(posedge STROBEG) begin
        if (CS) begin
            TIME_SR <= { COMMAND_SR, TIME_REG };
            $display("RTC strobed, data = %H", TIME_SR[47:0]);
            DATA_OUT <= TIME_SR[47:40]; // Correct this line to use non-blocking assignment
        end
    end

    always @(negedge OE) begin
        DATA_OUT <= 8'bz; // Allow output to be tri-state when OE is asserted
    end

endmodule