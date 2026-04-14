module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire config_req,
    input wire data_req,
    output reg [1:0] state_out
);
    // State Encoding
    localparam IDLE = 2'b00;
    localparam CONFIG = 2'b01;
    localparam DATA = 2'b10;

    // Current State
    reg [1:0] current_state, next_state;

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (config_req) begin
                    next_state = CONFIG;
                end else begin
                    next_state = IDLE;
                end
            end
            CONFIG: begin
                if (data_req) begin
                    next_state = DATA;
                end else begin
                    next_state = CONFIG;
                end
            end
            DATA: begin
                if (data_req) begin
                    next_state = DATA;
                end else begin
                    next_state = IDLE;  // Assume transition back to IDLE on no request
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        state_out = current_state;
    end
endmodule