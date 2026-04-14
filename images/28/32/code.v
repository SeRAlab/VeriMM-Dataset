module temperature_shutdown (
    input [7:0] temperature,
    output reg shutdown_signal
);

always @(*) begin
    if (temperature > 8'd75) 
        shutdown_signal = 1'b1;
    else 
        shutdown_signal = 1'b0;
end

endmodule