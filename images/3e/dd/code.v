module temperature_shutdown (
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg shutdown
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 1'b0;
        end else begin
            if (temperature > 8'd75) begin
                shutdown <= 1'b1; // Trigger shutdown
            end else begin
                shutdown <= 1'b0; // Normal operation
            end
        end
    end
endmodule