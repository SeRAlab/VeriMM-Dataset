module fan_speed_controller (
    input wire clk,
    input wire [7:0] temperature,
    output reg [1:0] speed
);

    always @(posedge clk) begin
        if (temperature < 8'd20) begin
            speed <= 2'b00; // LOW speed
        end else if (temperature >= 8'd20 && temperature <= 8'd30) begin
            speed <= 2'b01; // MEDIUM speed
        end else begin
            speed <= 2'b10; // HIGH speed
        end
    end
endmodule