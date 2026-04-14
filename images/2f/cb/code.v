module piso_shift_register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [3:0] data_in,
    output reg serial_out
);
    reg [3:0] shift_reg;
    reg [2:0] count; // to keep track of bits shifted out

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            count <= 3'b000;
            serial_out <= 1'b0;
        end else if (load) begin
            shift_reg <= data_in;
            count <= 3'b100; // Load the data and set count to 4 (3 bits for counting down)
        end else if (count > 0) begin
            serial_out <= shift_reg[3]; // Output the MSB
            shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
            count <= count - 1; // Decrease count
        end
    end
endmodule