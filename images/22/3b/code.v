module ARQ_System(
    input clk,
    input reset,
    input [7:0] data_in,
    input ack_nack,
    output reg [7:0] data_out,
    output reg resend
);
    reg [7:0] data_buffer;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            data_buffer <= 8'b0;
            resend <= 1'b0;
        end else begin
            data_buffer <= data_in; // Store incoming data
            if (ack_nack) begin // ACK received
                data_out <= data_buffer; // Data is accepted
                resend <= 1'b0; // No resend needed
            end else begin // NACK received
                resend <= 1'b1; // Resend the data
            end
        end
    end
endmodule