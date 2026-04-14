module top_module(
    input clk,
    input reset,
    input [11:0] temp_input,
    output reg [15:0] temp_output
);reg [11:0] temp_celsius;
    reg [15:0] temp_fahrenheit;

    always @ (posedge clk) begin
        if (reset) begin
            temp_celsius <= 32'h000;
        end
        else begin
            temp_celsius <= temp_input;
        end
    end

    always @ (temp_celsius) begin
        temp_fahrenheit = (temp_celsius * 9'b1011_0100) + 32'h0000;
        temp_output = temp_fahrenheit[15:6];
    end

endmodule