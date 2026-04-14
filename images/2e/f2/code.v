module bluetooth_packet_handler (
    input clk,
    input rst,
    input [4:0] packet_type,
    input valid,
    output reg [4:0] stored_packet
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        stored_packet <= 5'b00000; // Reset to default value
    end else if (valid) begin
        stored_packet <= packet_type; // Store packet type if valid
    end
    // If not valid, retain previous value (no action needed)
end

endmodule