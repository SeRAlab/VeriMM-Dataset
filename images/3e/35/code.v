module slam_state_machine (
    input wire clk,
    input wire rst,
    input wire start_map,
    input wire start_localize,
    output reg [1:0] state // 00: Idle, 01: Mapping, 10: Localizing
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // Idle
        end else begin
            case (state)
                2'b00: begin // Idle
                    if (start_map) state <= 2'b01; // Mapping
                    else if (start_localize) state <= 2'b10; // Localizing
                end
                2'b01: begin // Mapping
                    if (!start_map && !start_localize) state <= 2'b00; // Back to Idle
                end
                2'b10: begin // Localizing
                    if (!start_map && !start_localize) state <= 2'b00; // Back to Idle
                end
            endcase
        end
    end
endmodule