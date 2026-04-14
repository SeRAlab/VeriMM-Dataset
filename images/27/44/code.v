module temp_shutdown (
    input wire clk,
    input wire reset,
    input wire [3:0] temp,
    output reg shutdown
);
    parameter THRESHOLD = 4'b1010; // Threshold temperature

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0; // Reset shutdown signal
        end else begin
            if (temp > THRESHOLD) begin
                shutdown <= 1; // Assert shutdown
            end else begin
                shutdown <= 0; // Deassert shutdown
            end
        end
    end
endmodule