module serializer_32bit (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [31:0] parallel_in,
    output reg serial_out
);
    reg [4:0] counter; // 5 bits to count up to 32
    reg [31:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 5'b0;
            serial_out <= 1'b0;
            shift_reg <= 32'b0;
        end else if (enable) begin
            if (counter < 32) begin
                serial_out <= shift_reg[31]; // Output the MSB
                shift_reg <= {shift_reg[30:0], 1'b0}; // Shift left
                shift_reg[0] <= parallel_in[counter]; // Load the next bit
                counter <= counter + 1;
            end
        end
    end
endmodule