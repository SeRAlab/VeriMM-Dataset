module dvfs_control (
    input [1:0] voltage,
    input [2:0] load,
    output reg [1:0] frequency
);
    always @(*) begin
        case (voltage)
            2'b00: frequency = 2'b00;
            2'b01: begin
                case (load)
                    3'b000, 3'b001, 3'b010: frequency = 2'b01;
                    3'b011, 3'b100, 3'b101: frequency = 2'b10;
                    3'b110, 3'b111: frequency = 2'b11;
                    default: frequency = 2'b00; // default case
                endcase
            end
            2'b10: begin
                case (load)
                    3'b000, 3'b001, 3'b010: frequency = 2'b10;
                    3'b011, 3'b100, 3'b101, 3'b110, 3'b111: frequency = 2'b11;
                    default: frequency = 2'b00; // default case
                endcase
            end
            2'b11: frequency = 2'b11;
            default: frequency = 2'b00; // default case
        endcase
    end
endmodule