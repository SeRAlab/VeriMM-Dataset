module slam_fsm (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] sensor_data,
    output reg [1:0] state,
    output reg [15:0] processed_data
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam MAPPING = 2'b01;
    localparam LOCALIZING = 2'b10;

    // State transition
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            processed_data <= 0;
        end else begin
            case (state)
                IDLE: if (start) state <= MAPPING;
                MAPPING: begin
                    processed_data <= processed_data + sensor_data; // Simple processing
                    state <= LOCALIZING;
                end
                LOCALIZING: state <= IDLE; // Transition back to IDLE
                default: state <= IDLE;
            endcase
        end
    end
endmodule