module arq_system (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire parity_in,
    input wire request,
    output reg [7:0] data_out,
    output reg parity_out,
    output reg retransmit
);

reg [7:0] data_buffer;
reg parity_buffer;
reg error_detected;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0;
        parity_out <= 1'b0;
        retransmit <= 1'b0;
        data_buffer <= 8'b0;
        parity_buffer <= 1'b0;
        error_detected <= 1'b0;
    end else begin
        // Store incoming data and parity
        data_buffer <= data_in;
        parity_buffer <= parity_in;

        // Calculate parity
        parity_out <= ^data_buffer;

        // Check for error
        error_detected <= (parity_out != parity_buffer);

        // If error detected and request received, set retransmit
        if (error_detected) begin
            retransmit <= 1'b1;
        end else begin
            retransmit <= 1'b0;
            data_out <= data_buffer;
        end
    end
end

endmodule