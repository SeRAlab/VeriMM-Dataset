module ARQ_System(
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    input wire send,
    output reg ack,
    output reg [4:0] data_out
);
    reg [2:0] attempt_count;
    reg [4:0] sent_data;
    reg parity_check;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            attempt_count <= 3'b000;
            ack <= 0;
            data_out <= 5'b00000;
        end else begin
            if (send && attempt_count < 3) begin
                sent_data <= data_in;
                parity_check <= ^data_in; // Calculate parity (XOR of all bits)
                if (parity_check == 1'b0) begin // Even number of 1's
                    ack <= 1'b1; // Send ACK
                    data_out <= sent_data;
                    attempt_count <= 3'b000; // Reset attempt count
                end else begin // Odd number of 1's
                    ack <= 1'b0; // Send NACK
                    attempt_count <= attempt_count + 1; // Increment attempt count
                end
            end
        end
    end
endmodule