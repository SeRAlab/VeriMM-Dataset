module spi_controller (
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg transmitting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            shift_reg <= 8'b00000000;
            data_out <= 8'b00000000;
            done <= 0;
            transmitting <= 0;
        end else begin
            if (start && !transmitting) begin
                transmitting <= 1;
                shift_reg <= data_in;
                bit_count <= 3'b000;
                done <= 0;
            end else if (transmitting) begin
                if (bit_count < 3'b111) begin
                    bit_count <= bit_count + 1;
                    // Shift out the next bit (this is a simplification)
                    data_out[bit_count] <= shift_reg[7];
                    shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                end else begin
                    done <= 1;
                    transmitting <= 0;
                end
            end
        end
    end
endmodule