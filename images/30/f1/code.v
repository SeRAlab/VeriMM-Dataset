module temperature_shutdown(
    input wire clk,
    input wire reset,
    input wire [4:0] temperature,
    output reg shutdown
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else begin
            if (temperature > 5'b11100) begin
                shutdown <= 1;
            end else begin
                shutdown <= 0;
            end
        end
    end
endmodule