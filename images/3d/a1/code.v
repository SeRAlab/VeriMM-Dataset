module ARQ_System(
    input wire [4:0] data_in,
    input wire clk,
    input wire reset,
    output reg request_retransmission,
    output reg data_correct
);
    reg [4:0] received_data;
    reg parity_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            received_data <= 5'b0;
            parity_bit <= 1'b0;
            request_retransmission <= 1'b0;
            data_correct <= 1'b0;
        end else begin
            received_data <= data_in[4:0];
            parity_bit <= ^data_in; // Calculate parity
            if (parity_bit != data_in[4]) begin
                request_retransmission <= 1'b1; // Error detected
                data_correct <= 1'b0;
            end else begin
                request_retransmission <= 1'b0; // No error
                data_correct <= 1'b1;
            end
        end
    end
endmodule