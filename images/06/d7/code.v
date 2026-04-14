module temperature_shutdown (
    input [7:0] temperature,
    output reg shutdown
);
    always @* begin
        if (temperature > 75) begin
            shutdown = 1'b1; // Shutdown
        end else begin
            shutdown = 1'b0; // No Shutdown
        end
    end
endmodule