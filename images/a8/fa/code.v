module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    output reg pwm,   // 1-bit PWM output
    input [3:0] encoder_out,
    output reg [1:0] pos  );// 2-bit output indicating the highest priority input bit.

    reg [3:0] counter;
    reg [7:0] compare_value;
    reg [3:0] gray_code;
    reg [2:0] highest_priority;

    // Generate PWM signal with 100Hz frequency and 50% duty cycle
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            compare_value <= 8'd125;
            pwm <= 1'b0;
        end else begin
            if (counter == compare_value) begin
                counter <= 4'b0000;
                pwm <= ~pwm;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Convert binary to gray code
    always @(encoder_out) begin
        gray_code[0] = encoder_out[0];
        gray_code[1] = encoder_out[0] ^ encoder_out[1];
        gray_code[2] = encoder_out[1] ^ encoder_out[2];
        gray_code[3] = encoder_out[2] ^ encoder_out[3];
    end

    // Convert gray code to one-hot code
    always @(gray_code) begin
        case (gray_code)
            4'b0001: highest_priority = 3'b001;
            4'b0010: highest_priority = 3'b010;
            4'b0100: highest_priority = 3'b100;
            4'b1000: highest_priority = 3'b000;
            default: highest_priority = 3'b000;
        endcase
    end

    // Output the highest priority input bit
    always @(highest_priority) begin
        case (highest_priority)
            3'b001: pos = 2'b01;
            3'b010: pos = 2'b10;
            3'b100: pos = 2'b11;
            default: pos = 2'b00;
        endcase
    end

endmodule