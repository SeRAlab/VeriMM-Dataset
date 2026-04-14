module temp_shutdown (
    input clk,
    input reset,
    input [7:0] temperature,
    input shutdown_signal,
    output reg shutdown
);
    parameter THRESHOLD = 8'd75;
    parameter DELAY = 5;
    
    reg [2:0] count;
    reg temp_exceeded;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
            count <= 0;
            temp_exceeded <= 0;
        end else begin
            if (shutdown_signal && temperature > THRESHOLD) begin
                temp_exceeded <= 1;
            end
            
            if (temp_exceeded) begin
                if (count < DELAY) begin
                    count <= count + 1;
                end else begin
                    shutdown <= 1;
                end
            end
            
            if (!shutdown_signal) begin
                temp_exceeded <= 0;
                count <= 0;
                shutdown <= 0;
            end
        end
    end
endmodule