module serializer (
    input clk,
    input reset,
    input enable,
    input [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_count; // To keep track of which bit to send
    reg [7:0] shift_reg; // To store the input data

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b0;
            serial_out <= 1'b0;
            shift_reg <= 8'b0;
        end else if (enable) begin
            if (bit_count < 3'b111) begin
                serial_out <= shift_reg[7]; // Send the MSB first
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                bit_count <= bit_count + 1'b1;
            end else begin
                shift_reg <= data_in; // Load new data when done
                bit_count <= 3'b0; // Reset count
            end
        end
    end
endmodule