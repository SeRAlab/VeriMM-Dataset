module temp_shutdown (
    input wire [6:0] temperature,
    input wire reset,
    input wire clk,
    output reg shutdown
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shutdown <= 0;
    end else begin
        if (temperature > 100) begin
            shutdown <= 1;
        end else begin
            shutdown <= 0;
        end
    end
end

endmodule