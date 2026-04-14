module temp_shutdown (
    input [3:0] temperature,
    input reset,
    input clk,
    output reg shutdown
);
    parameter THRESHOLD = 4'b1100; // 12 degrees Celsius

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else if (temperature > THRESHOLD) begin
            shutdown <= 1;
        end
    end
endmodule