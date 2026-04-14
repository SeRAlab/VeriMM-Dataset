module temperature_sensor (
    input clk,
    input reset,
    input [9:0] temp_in,
    output reg alert,
    output reg [9:0] last_temp
);

    parameter THRESHOLD = 10'b01001011; // 75 in binary

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 0;
            last_temp <= 10'b0;
        end else begin
            last_temp <= temp_in;
            if (temp_in > THRESHOLD) begin
                alert <= 1;
            end else begin
                alert <= 0;
            end
        end
    end
endmodule