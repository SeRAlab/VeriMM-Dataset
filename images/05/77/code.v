module temperature_shutdown (
    input clk,
    input reset,
    input [4:0] current_temp,
    output reg shutdown_signal
);
    parameter THRESHOLD = 5'd25;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            shutdown_signal <= 1'b0;
        else if (current_temp > THRESHOLD) 
            shutdown_signal <= 1'b1;
        else 
            shutdown_signal <= 1'b0;
    end
endmodule