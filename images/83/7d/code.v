module top_module(
    areset,
    inclk0,
    c0
);input areset;
    input inclk0;
    output reg c0; // Changed from wire to reg

    // Phase detector
    wire phase_error;
    reg phase_error_d1;
    always @(posedge inclk0 or negedge areset) begin
        if (~areset) begin
            phase_error_d1 <= 0;
        end else begin
            phase_error_d1 <= phase_error;
        end
    end

    assign phase_error = (c0 == 1'b1) ? ~inclk0 : inclk0;

    // Charge pump
    reg [7:0] charge_pump_out;
    always @(posedge inclk0 or negedge areset) begin
        if (~areset) begin
            charge_pump_out <= 0;
        end else begin
            charge_pump_out <= (phase_error & (charge_pump_out < 8'h7f)) ? charge_pump_out + 1 : 
                               (~phase_error & (charge_pump_out > 8'h80)) ? charge_pump_out - 1 : charge_pump_out;
        end
    end

    // Loop filter
    reg [15:0] loop_filter_out;
    always @(posedge inclk0 or negedge areset) begin
        if (~areset) begin
            loop_filter_out <= 16'h0000;
        end else begin
            loop_filter_out <= loop_filter_out + charge_pump_out;
        end
    end

    // Voltage-controlled oscillator (VCO)
    reg [31:0] vco_out;
    always @(posedge inclk0 or negedge areset) begin
        if (~areset) begin
            vco_out <= 32'h00000000;
        end else begin
            vco_out <= vco_out + loop_filter_out;
        end
    end

    // Divide-by-2
    reg [31:0] div_by_2_out;
    always @(posedge vco_out[31] or negedge areset) begin
        if (~areset) begin
            div_by_2_out <= 32'h00000000;
        end else begin
            div_by_2_out <= {vco_out[30:0], ~vco_out[31]};
        end
    end

    // Output clock signal
    always @(posedge inclk0 or negedge areset) begin
        if (~areset) begin
            c0 <= 0;
        end else begin
            c0 <= div_by_2_out[31];
        end
    end

endmodule