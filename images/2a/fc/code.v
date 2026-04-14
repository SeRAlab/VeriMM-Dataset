module temp_shutdown (
    input clk,
    input reset,
    input [4:0] temperature,
    output reg shutdown
);
    parameter THRESHOLD = 25;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else begin
            if (temperature > THRESHOLD) begin
                shutdown <= 1;
            end
        end
    end
endmodule