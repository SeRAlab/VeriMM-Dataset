module top_module(
    input wire d,
    input wire [3:0] hightime,
    input wire [3:0] deadtime,
    input wire CLK,
    output wire pulse,
    output wire gate_closed,
    input wire reset
);reg closed;
    reg signal_entered;
    reg output_pulse;

    wire delay_hightime;
    wire delay_deadtime;

    reg hightime_reset;
    reg deadtime_reset;

    // Simple Shift Register for Hightime delay
    reg [15:0] hightime_shift_reg;
    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            hightime_shift_reg <= 16'b0;
        end else begin
            hightime_shift_reg <= {hightime_shift_reg[14:0], signal_entered};
        end
    end
    assign delay_hightime = hightime_shift_reg[hightime];

    // Simple Shift Register for Deadtime delay
    reg [15:0] deadtime_shift_reg;
    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            deadtime_shift_reg <= 16'b0;
        end else begin
            deadtime_shift_reg <= {deadtime_shift_reg[14:0], delay_hightime};
        end
    end
    assign delay_deadtime = deadtime_shift_reg[deadtime];

    // Handle asynchronous reset
    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            hightime_reset <= 1'b1;
            deadtime_reset <= 1'b1;
            closed <= 1'b0;
            signal_entered <= 1'b0;
            output_pulse <= 1'b0;
        end else begin
            hightime_reset <= delay_hightime;
            deadtime_reset <= delay_deadtime;
            signal_entered <= d; // Updated to use non-blocking assignment
            if (hightime_reset) output_pulse <= 1'b0;
            else if (signal_entered) output_pulse <= 1'b1;
            if (deadtime_reset) closed <= 1'b0;
            else if (signal_entered) closed <= 1'b1;
        end
    end

    assign pulse = output_pulse;
    assign gate_closed = signal_entered || closed;

endmodule