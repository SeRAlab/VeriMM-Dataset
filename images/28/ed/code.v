module arq_system (
    input clk,
    input rst,
    input [3:0] data_in,      // 4-bit input data
    output reg ack_nack       // ACK = 1, NACK = 0
);
    parameter CODEWORD = 4'b1010; // Predefined codeword for checking

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack_nack <= 1'b0; // Reset state
        end else begin
            if (data_in == CODEWORD) begin
                ack_nack <= 1'b1; // Send ACK
            end else begin
                ack_nack <= 1'b0; // Send NACK
            end
        end
    end
endmodule