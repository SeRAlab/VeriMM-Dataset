module top_module(
    input logic [3:0] input_num,
    output logic [2:0] output_mag
);always_comb begin
        case(input_num)
            4'b0000: output_mag = 3'b000;
            4'b0001, 4'b0010: output_mag = 3'b001;
            4'b0011, 4'b0100, 4'b1000: output_mag = 3'b010;
            4'b0101, 4'b0110, 4'b1001, 4'b1010: output_mag = 3'b011;
            4'b0111, 4'b1011, 4'b1100: output_mag = 3'b100;
            4'b1101, 4'b1110: output_mag = 3'b101;
            4'b1111: output_mag = 3'b111;
        endcase
    end

endmodule