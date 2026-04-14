module ARQ_Error_Correction(
    input wire clk,
    input wire [7:0] data_in,
    input wire parity_in,
    output reg data_correct,
    output reg request_retransmission
);
    reg [7:0] received_data;
    reg calculated_parity;

    always @(posedge clk) begin
        received_data <= data_in;
        calculated_parity <= ^data_in; // Calculate parity by XORing all bits
        if (calculated_parity == parity_in) begin
            data_correct <= 1;
            request_retransmission <= 0;
        end else begin
            data_correct <= 0;
            request_retransmission <= 1;
        end
    end
endmodule