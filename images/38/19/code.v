module ARQ (
    input clk,
    input rst,
    input [7:0] data_in,
    input send,       
    output reg [7:0] data_out,
    output reg error,
    output reg request,
    input ack
);
    reg [2:0] attempt_count;
    reg [7:0] current_data;
    reg parity;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            attempt_count <= 0;
            request <= 0;
            error <= 0;
            data_out <= 0;
        end else begin
            if (send) begin
                current_data <= data_in;
                parity <= ^current_data; // Calculate parity
                data_out <= {current_data, parity}; // Send data with parity
                attempt_count <= attempt_count + 1;
                request <= 0; // No request initially
            end
            
            if (ack) begin
                if (parity == 1'b1) begin // If parity bit is 1, no error
                    attempt_count <= 0; // Reset on successful reception
                    request <= 0;
                end else begin
                    error <= 1; // Error detected
                    request <= 1; // Request retransmission
                end
            end
            
            if (attempt_count >= 3) begin
                // Handle maximum retry
                attempt_count <= 0; // Reset attempt count
                request <= 0; // Stop requests after max attempts
            end
        end
    end
endmodule