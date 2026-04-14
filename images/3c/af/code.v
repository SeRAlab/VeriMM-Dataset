module ARQ_Controller (
    input wire clk,
    input wire data_in,
    input wire ack_in,
    output reg data_out
);
    reg data_stored;

    always @(posedge clk) begin
        if (ack_in) begin
            data_stored <= 0; // Clear stored data on successful ACK
            data_out <= data_stored; // Output the stored data
        end else begin
            data_stored <= data_in; // Store incoming data on error
            data_out <= data_stored; // Output the stored data
        end
    end
endmodule