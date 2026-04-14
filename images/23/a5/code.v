module nvme_controller (
    input clk,
    input reset,
    input start,
    output reg [1:0] state // 00: IDLE, 01: PROCESSING, 10: DONE
);
    parameter PROCESSING_CYCLES = 4; // Number of clock cycles to stay in PROCESSING
    reg [2:0] cycle_count; // Counter for processing cycles

    // State encoding
    localparam IDLE = 2'b00;
    localparam PROCESSING = 2'b01;
    localparam DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            cycle_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= PROCESSING;
                        cycle_count <= 0;
                    end
                end
                
                PROCESSING: begin
                    if (cycle_count < PROCESSING_CYCLES - 1) begin
                        cycle_count <= cycle_count + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    state <= IDLE; // Automatically return to IDLE
                end
                
                default: state <= IDLE; // Fallback to IDLE
            endcase
        end
    end
endmodule