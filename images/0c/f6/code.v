module TemperatureSensor (
    input wire clk,
    input wire enable,
    input wire [3:0] temp_in,
    output reg [3:0] temp_out,
    output reg temp_changed
);
    always @(posedge clk) begin
        if (enable) begin
            temp_out <= temp_in;
            temp_changed <= 1;
        end else begin
            temp_changed <= 0;
        end
    end
endmodule