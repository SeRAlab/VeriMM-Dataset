module temp_shutdown_controller(
    input clk,
    input rst,
    input [7:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 8'd75;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 1'b0;  // Reset shutdown state
        end else begin
            if (temperature > THRESHOLD) begin
                shutdown <= 1'b1;  // Trigger shutdown
            end else begin
                shutdown <= 1'b0;  // Normal operation
            end
        end
    end
endmodule