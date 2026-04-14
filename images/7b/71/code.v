module top_module(
    input [8:0] key_input,
    output reg [4:0] led_output
);always @*
    begin
        case(key_input)
            9'b000000001: led_output = 5'b00001;
            9'b000000010: led_output = 5'b00010;
            9'b000000100: led_output = 5'b00100;
            9'b000001000: led_output = 5'b01000;
            9'b000010000: led_output = 5'b10000;
            9'b000100000: led_output = 5'b00000;
            9'b001000000: led_output = 5'b11111;
            default: led_output = 5'bxxxxx;
        endcase
    end

endmodule