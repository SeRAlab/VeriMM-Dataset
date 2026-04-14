module temp_shutdown_controller(
    input wire clk,
    input wire reset,
    input wire [7:0] temp,
    output reg shutdown
);
    parameter THRESHOLD = 8'd100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 1'b0;
        end else begin
            if (temp > THRESHOLD) begin
                shutdown <= 1'b1; // Trigger shutdown
            end else begin
                shutdown <= 1'b0; // Normal operation
            end
        end
    end
endmodule