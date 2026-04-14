module slam_system (
    input clk,
    input reset,
    input [7:0] sensor_data, // Example sensor data
    output reg [15:0] pos_x,
    output reg [15:0] pos_y
);
    reg [1:0] state;
    reg [15:0] new_x, new_y;

    localparam IDLE = 2'b00,
               PROCESS = 2'b01,
               UPDATE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            pos_x <= 16'b0;
            pos_y <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (sensor_data != 8'b0) begin
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    // Simple processing logic to update new_x and new_y based on sensor_data
                    new_x <= pos_x + sensor_data; // Example logic
                    new_y <= pos_y + sensor_data; // Example logic
                    state <= UPDATE;
                end
                UPDATE: begin
                    pos_x <= new_x;
                    pos_y <= new_y;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule