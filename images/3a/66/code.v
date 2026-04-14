module fan_speed_control(
    input clk,
    input rst,
    input [1:0] speed_input, // 00 - OFF, 01 - LOW, 10 - MEDIUM, 11 - HIGH
    output reg [1:0] speed_output // 00 - OFF, 01 - LOW, 10 - MEDIUM, 11 - HIGH
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            speed_output <= 2'b00; // OFF state on reset
        end else begin
            case (speed_input)
                2'b00: speed_output <= 2'b00; // OFF
                2'b01: speed_output <= 2'b01; // LOW
                2'b10: speed_output <= 2'b10; // MEDIUM
                2'b11: speed_output <= 2'b11; // HIGH
                default: speed_output <= speed_output; // Maintain current state
            endcase
        end
    end
endmodule