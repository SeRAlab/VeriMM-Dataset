module ARQ_system (
    input wire clk,
    input wire rst,
    input wire [4:0] data_in,    // 5-bit data input
    input wire request,          // Request signal from receiver
    output reg [4:0] data_out,   // 5-bit data output
    output reg ack               // Acknowledgment signal
);
    reg [4:0] sent_data;
    reg error_detected;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sent_data <= 5'b00000;
            data_out <= 5'b00000;
            ack <= 0;
            error_detected <= 0;
        end else begin
            if (request) begin
                // Request to resend the last data
                data_out <= sent_data;
                ack <= 0; // Not acknowledged until data received
            end else begin
                // Simulate error detection (for example, by flipping a bit)
                error_detected <= (data_in != sent_data);
                if (error_detected) begin
                    ack <= 0; // Signal that error was detected
                end else begin
                    sent_data <= data_in;
                    ack <= 1; // Acknowledge that data is received correctly
                end
            end
        end
    end
endmodule