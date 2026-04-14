module top_module(
    input clk,
    input reset,
    input [15:0] input_signal,
    output reg [7:0] motor_speed
);reg [15:0] temp_signal;

    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            temp_signal <= 0;
            motor_speed <= 0;
        end else begin
            temp_signal <= input_signal;
            if (input_signal <= 32767) begin
                motor_speed <= input_signal >> 7;
            end else begin
                motor_speed <= input_signal >> 8;
            end
        end
    end

endmodule