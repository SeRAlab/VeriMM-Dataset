module ARQ_System(
    input clk,
    input reset,
    input [3:0] data_in,
    input valid,
    output reg [3:0] data_out,
    output reg ack,
    output reg error
);

reg [3:0] data_buffer;
reg parity_bit;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_buffer <= 4'b0000;
        parity_bit <= 1'b0;
        ack <= 1'b0;
        error <= 1'b0;
    end else if (valid) begin
        // Generate parity bit
        parity_bit <= ^data_in;
        data_buffer <= data_in;
        ack <= 1'b0; // Reset ack
    end
end

always @(posedge clk) begin
    if (valid) begin
        // Simulate receiving the data and parity
        if (parity_bit == ^data_buffer) begin
            data_out <= data_buffer; // Data is correct
            ack <= 1'b1; // Acknowledge reception
            error <= 1'b0;
        end else begin
            error <= 1'b1; // Error detected
            data_out <= 4'b0000; // Invalid data output
        end
    end
end

endmodule