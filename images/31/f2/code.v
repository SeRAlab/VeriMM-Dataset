module ARQ (
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    input wire ack, // Acknowledgment from the receiver
    output reg [4:0] data_out,
    output reg resend // Flag to indicate if data should be resent
);
    reg [4:0] data_buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_buffer <= 5'b0;
            data_out <= 5'b0;
            resend <= 1'b0;
        end else begin
            // Store the data
            data_buffer <= data_in;

            // Check for even parity
            if (^(data_buffer) == 1'b0) begin
                // If parity is correct, send data and clear resend flag
                data_out <= data_buffer;
                resend <= 1'b0;
            end else begin
                // If parity is incorrect, set resend flag
                resend <= 1'b1;
            end

            // If acknowledgment is negative, resend
            if (!ack) begin
                data_out <= data_buffer; // Resend the last data
            end
        end
    end
endmodule