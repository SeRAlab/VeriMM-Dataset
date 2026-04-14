module ARQ_System (
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] data_out,
    output reg ack,
    output reg request_retransmit
);
    reg [7:0] last_ack_data;
    reg [7:0] received_data;
    reg last_parity_bit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            last_ack_data <= 8'b0;
            data_out <= 8'b0;
            ack <= 0;
            request_retransmit <= 0;
            last_parity_bit <= 0;
        end else begin
            if (data_valid) begin
                received_data <= data_in;
                last_parity_bit <= ^received_data; // Compute parity
                if (last_parity_bit) begin
                    data_out <= received_data; // Valid data
                    ack <= 1;
                    last_ack_data <= received_data;
                    request_retransmit <= 0;
                end else begin
                    ack <= 0;
                    request_retransmit <= 1; // Request retransmission
                end
            end
        end
    end
endmodule