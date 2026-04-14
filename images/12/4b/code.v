module ARQ_Controller (
    input wire clk,
    input wire reset,
    input wire data_received, // 1 for correct reception, 0 for incorrect
    output reg [1:0] state // 00 for ACK, 01 for NACK
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initial state (ACK)
        end else begin
            if (data_received) begin
                state <= 2'b00; // ACK
            end else begin
                state <= 2'b01; // NACK
            end
        end
    end
endmodule