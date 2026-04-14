module top_module(
    input CLOCK_50,
    input [1:0] KEY,
    input RESET,
    output reg [7:0] LED
);always @(posedge CLOCK_50 or posedge RESET) begin
        if (RESET) begin
            LED <= 8'b0;
        end else begin
            case (KEY)
                2'b00: LED <= 8'b00000001; // turn on LED[0] if key 0 is pressed
                2'b01: LED <= 8'b00000010; // turn on LED[1] if key 1 is pressed
                2'b10: LED <= 8'b0;        // turn off all LEDs if both keys are pressed
                2'b11: LED <= 8'b0;        // turn off all LEDs if both keys are pressed
            endcase
        end
    end

endmodule