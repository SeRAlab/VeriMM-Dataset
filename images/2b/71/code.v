module dvfs_controller(
    input clk,
    input reset,
    input [1:0] load,
    output reg [1:0] frequency,
    output reg [1:0] voltage
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        frequency <= 2'b00;
        voltage <= 2'b00;
    end else begin
        case (load)
            2'b00: begin
                frequency <= 2'b00; // Low frequency
                voltage <= 2'b00;   // Low voltage
            end
            2'b01: begin
                frequency <= 2'b01; // Medium frequency
                voltage <= 2'b01;   // Medium voltage
            end
            2'b10: begin
                frequency <= 2'b10; // High frequency
                voltage <= 2'b10;   // High voltage
            end
            default: begin
                frequency <= 2'b11; // Invalid state
                voltage <= 2'b11;   // Invalid state
            end
        endcase
    end
end

endmodule