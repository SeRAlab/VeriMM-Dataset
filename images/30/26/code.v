module temp_shutdown_controller (
    input clk,
    input rst,
    input [7:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 8'd80;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 1'b0;
        end else if (temperature > THRESHOLD) begin
            shutdown <= 1'b1;
        end else begin
            shutdown <= 1'b0;
        end
    end
endmodule