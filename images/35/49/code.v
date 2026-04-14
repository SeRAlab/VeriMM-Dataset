module pcie_packet_checker(
    input wire clk,
    input wire rst_n,
    input wire [127:0] packet_data, // 128-bit packet data
    output reg valid // Output signal for valid packet
);
    
    reg [7:0] packet_length; // Packet length
    reg [127:0] header; // Predefined header
    reg [127:0] checksum; // Checksum calculation
    reg [127:0] calculated_checksum; // Store calculated checksum

    initial begin
        header = 128'hABCD_ABCD_ABCD_ABCD; // Example header
        packet_length = 0;
        valid = 0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid <= 0;
            packet_length <= 0;
        end else begin
            // Check if the packet starts with the correct header
            if (packet_data[127:0] == header) begin
                // Extract the length from the packet
                packet_length <= packet_data[119:112]; // Assuming length is in certain bits
                // Calculate checksum (example: sum of the first 120 bits)
                calculated_checksum <= packet_data[111:0]; // Simple checksum example
                checksum <= packet_data[127:120]; // Assume checksum is in bits [127:120]
                
                // Validate length and checksum
                if (packet_length <= 64 && checksum == calculated_checksum) begin
                    valid <= 1; // Packet is valid
                end else begin
                    valid <= 0; // Packet is invalid
                end
            end else begin
                valid <= 0; // Invalid header
            end
        end
    end
endmodule