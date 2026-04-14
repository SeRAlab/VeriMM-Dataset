module PISO(
    input wire clk,
    input wire load,
    input wire reset,
    input wire [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 5'b0;
            bit_count <= 3'b0;
            serial_out <= 1'b0;
        end else if (load) begin
            shift_reg <= parallel_in;
            bit_count <= 3'b0; // reset bit count when loading new data
        end else if (bit_count < 5) begin
            serial_out <= shift_reg[4]; // output the MSB
            shift_reg <= {shift_reg[3:0], 1'b0}; // shift left
            bit_count <= bit_count + 1;
        end
    end
endmodule