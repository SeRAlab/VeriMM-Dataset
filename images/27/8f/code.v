module pcie_receiver (
    input wire clk,
    input wire rst,
    input wire [31:0] data_in,
    input wire packet_valid,
    output reg ack,
    output reg status
);
    reg [31:0] packet_buffer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
            status <= 0;
            packet_buffer <= 0;
        end else begin
            if (packet_valid) begin
                packet_buffer <= data_in;
                ack <= 1; // Acknowledge the packet
                status <= 1; // Indicate valid packet
            end else begin
                ack <= 0; // No acknowledgment
                status <= 0; // No valid packet
            end
        end
    end
endmodule