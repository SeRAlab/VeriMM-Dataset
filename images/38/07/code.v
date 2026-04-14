module dvfs_controller(
    input wire clk,
    input wire [3:0] load,
    output reg [2:0] voltage,
    output reg [2:0] frequency
);

always @(posedge clk) begin
    case (load)
        4'b0000, 4'b0001, 4'b0010, 4'b0011: begin
            voltage <= 3'b000;
            frequency <= 3'b000;
        end
        4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
            voltage <= 3'b001;
            frequency <= 3'b001;
        end
        4'b1000, 4'b1001, 4'b1010, 4'b1011: begin
            voltage <= 3'b010;
            frequency <= 3'b010;
        end
        4'b1100, 4'b1101, 4'b1110, 4'b1111: begin
            voltage <= 3'b011;
            frequency <= 3'b011;
        end
        default: begin
            voltage <= 3'b000;
            frequency <= 3'b000;
        end
    endcase
end

endmodule