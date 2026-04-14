module temp_shutdown (
    input wire [7:0] temperature,
    input wire reset,
    input wire clk,
    output reg shutdown
);

    parameter THRESHOLD = 8'd75;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else begin
            if (temperature > THRESHOLD) begin
                shutdown <= 1;
            end else begin
                shutdown <= 0;
            end
        end
    end
endmodule