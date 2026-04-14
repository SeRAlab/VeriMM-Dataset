module serializer (
    input clk,
    input reset,
    input [7:0] parallel_in,
    output reg serial_out,
    output reg valid
);
    reg [2:0] count; // 3-bit counter for counting bits
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            serial_out <= 1'b0;
            valid <= 1'b0;
            shift_reg <= 8'b0;
        end else begin
            if (count == 3'b000) begin
                shift_reg <= parallel_in; // Load parallel input
                valid <= 1'b1; // Set valid signal
            end
            
            if (count < 3'b111) begin
                serial_out <= shift_reg[7]; // Output the MSB
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                count <= count + 1; // Increment counter
            end else begin
                serial_out <= 1'b0; // Output zero when done
                valid <= 1'b0; // Clear valid signal
                count <= 3'b000; // Reset counter
            end
        end
    end
endmodule