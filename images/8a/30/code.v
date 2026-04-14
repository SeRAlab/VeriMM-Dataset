module top_module(
    input wire clk,
    input wire [4:0] button,
    input wire [7:0] SW,
    output reg [4:0] button_out,
    output reg [4:0] button_pulse,
    output reg [7:0] SW_OK
);reg [4:0] button_temp;
    reg [7:0] SW_temp;
    reg [31:0] counter;
    reg pulse;

    always @(posedge clk) begin
        button_temp <= button;
        SW_temp <= SW;
        if (button_temp != button || SW_temp != SW) begin
            counter <= 0;
            pulse <= 0;
        end else if (counter < 100000) begin
            counter <= counter + 1;
        end else begin
            button_out <= button;
            if (button_temp == 0 && pulse == 1) begin
                button_pulse <= button_temp;
                pulse <= 0;
            end else if (button_temp == 1) begin
                pulse <= 1;
            end
            SW_OK <= SW_temp;
        end
    end

endmodule