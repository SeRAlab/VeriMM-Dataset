module serializer (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire [4:0] control, // Number of bits to serialize
    output reg serial_out
);
    reg [4:0] count; // Count the serialized bits
    reg [31:0] shift_reg; // Shift register to hold data

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            serial_out <= 0;
            shift_reg <= data_in;
        end else if (control > 0 && count < control) begin
            serial_out <= shift_reg[31]; // Output the MSB
            shift_reg <= {shift_reg[30:0], 1'b0}; // Shift left
            count <= count + 1;
        end else if (count == control) begin
            count <= 0; // Reset count
            shift_reg <= data_in; // Reload data
        end
    end
endmodule