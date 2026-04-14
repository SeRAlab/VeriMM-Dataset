module DVFS_Controller(
    input [2:0] load,
    output reg [1:0] frequency,
    output reg [1:0] voltage
);
    
    always @(*) begin
        case (load)
            3'b000, 3'b001: begin
                frequency = 2'b00; // 00
                voltage = 2'b00;   // 00
            end
            3'b010, 3'b011, 3'b100: begin
                frequency = 2'b01; // 01
                voltage = 2'b01;   // 01
            end
            3'b101, 3'b110, 3'b111: begin
                frequency = 2'b10; // 10
                voltage = 2'b10;   // 10
            end
            default: begin
                frequency = 2'b00; // Default case
                voltage = 2'b00;   // Default case
            end
        endcase
    end
endmodule