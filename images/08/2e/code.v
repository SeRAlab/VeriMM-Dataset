module temp_shutdown (
    input [7:0] temperature, // 8-bit temperature input
    output reg shutdown        // Shutdown signal
);
    always @(*) begin
        if (temperature > 75)
            shutdown = 1'b1; // Shutdown signal high
        else
            shutdown = 1'b0; // Shutdown signal low
    end
endmodule