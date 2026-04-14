module temp_sensor_controller(
    input wire clk,
    input wire rst,
    input wire [7:0] temp_in,
    output reg [7:0] last_temp,
    output reg alert
);
    // State declaration
    reg state;

    // State encoding
    localparam IDLE = 1'b0;
    localparam ALERT = 1'b1;

    // Sequential logic for state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            last_temp <= 8'b0;
            alert <= 1'b0;
            state <= IDLE;
        end else begin
            last_temp <= temp_in;
            if (temp_in > 8'd75) begin
                alert <= 1'b1;
                state <= ALERT;
            end else begin
                alert <= 1'b0;
                state <= IDLE;
            end
        end
    end
endmodule