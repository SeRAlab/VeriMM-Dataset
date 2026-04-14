module ARQ (
    input wire clk,
    input wire reset,
    input wire [4:0] data_in,
    input wire ack,
    output reg [4:0] data_out
);
    reg [4:0] stored_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 5'b00000;
            stored_data <= 5'b00000;
        end else begin
            if (ack) begin
                data_out <= data_in; // Correctly received data
                stored_data <= 5'b00000; // Clear stored data
            end else begin
                stored_data <= data_in; // Store data for retransmission
                data_out <= stored_data; // Output stored data
            end
        end
    end
endmodule