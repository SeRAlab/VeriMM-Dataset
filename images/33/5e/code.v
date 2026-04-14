module deserializer (
    input wire clk,          // Clock input
    input wire reset,        // Reset input
    input wire serial_in,    // Serial input bit
    output reg [7:0] parallel_out, // 8-bit parallel output
    output reg valid         // Output valid signal
);
    reg [2:0] bit_count;  // Count the number of bits received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 8'b0;
            valid <= 0;
            bit_count <= 3'b0;
        end else begin
            if (bit_count < 3'd8) begin
                parallel_out <= {parallel_out[6:0], serial_in}; // Shift in the new bit
                bit_count <= bit_count + 1'b1; // Increment the bit count
            end
            
            if (bit_count == 3'd7) begin
                valid <= 1; // Set valid high when 8 bits are received
            end else begin
                valid <= 0; // Set valid low otherwise
            end
        end
    end
endmodule