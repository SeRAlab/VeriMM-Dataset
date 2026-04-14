module phase_shifter (
    input wire clk,
    input wire [1:0] control,
    output reg shifted_clk
);
    reg [1:0] state;
    
    // State encoding for phase shifts
    parameter IDLE = 2'b00;   // 0 degrees
    parameter PHASE_90 = 2'b01; // 90 degrees
    parameter PHASE_180 = 2'b10; // 180 degrees
    parameter PHASE_270 = 2'b11; // 270 degrees

    always @(posedge clk) begin
        case(control)
            2'b00: state <= IDLE;
            2'b01: state <= PHASE_90;
            2'b10: state <= PHASE_180;
            2'b11: state <= PHASE_270;
            default: state <= IDLE;
        endcase
    end
    
    always @(posedge clk) begin
        case(state)
            IDLE: shifted_clk <= clk;
            PHASE_90: shifted_clk <= ~clk; // Invert clock for 90 degrees
            PHASE_180: shifted_clk <= ~clk; // Invert clock for 180 degrees
            PHASE_270: shifted_clk <= clk; // For 270 degrees, keep original
            default: shifted_clk <= clk;
        endcase
    end
endmodule