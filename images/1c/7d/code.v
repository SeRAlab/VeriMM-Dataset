module eth_mac_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg ack_out
);
    reg [7:0] packet_buffer;
    reg processing;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            packet_buffer <= 8'b0;
            ack_out <= 1'b0;
            processing <= 1'b0;
        end else begin
            if (!processing) begin
                packet_buffer <= data_in;
                processing <= 1'b1;
            end else begin
                ack_out <= 1'b1; // Acknowledge processing
                processing <= 1'b0; // Ready for next packet
            end
        end
    end
endmodule