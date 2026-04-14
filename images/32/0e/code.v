module dvfs_controller (
    input wire [3:0] load,
    output reg [2:0] frequency,
    output reg [2:0] voltage
);

always @(load) begin
    case (load)
        4'b0000: begin
            frequency = 3'b000;
            voltage = 3'b000;
        end
        4'b0001: begin
            frequency = 3'b001;
            voltage = 3'b001;
        end
        4'b0010: begin
            frequency = 3'b010;
            voltage = 3'b010;
        end
        4'b0011: begin
            frequency = 3'b011;
            voltage = 3'b011;
        end
        4'b0100: begin
            frequency = 3'b100;
            voltage = 3'b100;
        end
        4'b0101: begin
            frequency = 3'b101;
            voltage = 3'b101;
        end
        4'b0110: begin
            frequency = 3'b110;
            voltage = 3'b110;
        end
        default: begin
            frequency = 3'b111;
            voltage = 3'b111;
        end
    endcase
end

endmodule