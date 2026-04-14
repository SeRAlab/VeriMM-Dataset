module top_module(
    input clk,
    input [3:0] button,
    input [7:0] SW,
    output reg [3:0] button_out,
    output reg [7:0] SW_OK
);reg [31:0] counter = 0;
reg button_pressed = 0;
reg button_released = 0;
reg [3:0] button_state = 0;

always @(posedge clk) begin
    if (button == 1 && !button_pressed) begin
        counter <= 0;
        button_pressed <= 1;
        button_released <= 0;
    end else if (button == 0 && !button_released) begin
        button_pressed <= 0;
        button_released <= 1;
    end else if (button_pressed) begin
        if (counter < 100000) begin
            counter <= counter + 1;
        end else begin
            button_state <= button;
            button_out <= button_state;
            SW_OK <= (button_state == 1) ? SW : 0;
            button_pressed <= 0;
        end
    end
end

endmodule