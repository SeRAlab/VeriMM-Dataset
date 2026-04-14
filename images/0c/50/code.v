module temp_shutdown_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg shutdown
);

    parameter THRESHOLD = 8'd100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else if (temperature >= THRESHOLD) begin
            shutdown <= 1;
        end else begin
            shutdown <= 0;
        end
    end
endmodule