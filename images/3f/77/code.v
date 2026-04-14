module arq_system(
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    input wire parity_in,
    output reg [4:0] data_out,
    output reg is_correct,
    output reg request_retransmission
);

    reg [4:0] received_data;
    reg parity_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 5'b00000;
            is_correct <= 1'b0;
            request_retransmission <= 1'b0;
        end else begin
            received_data <= data_in;
            parity_bit <= parity_in;

            // Check parity
            if (^received_data === parity_bit) begin
                is_correct <= 1'b1;
                request_retransmission <= 1'b0;
                data_out <= received_data;
            end else begin
                is_correct <= 1'b0;
                request_retransmission <= 1'b1;
            end
        end
    end
endmodule