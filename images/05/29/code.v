module dvfs_controller(
    input [3:0] load,
    input clk,
    input reset,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voltage <= 2'b00;
            frequency <= 2'b00;
        end else begin
            case (load)
                4'b0000, 4'b0001, 4'b0010, 4'b0011: begin
                    voltage <= 2'b00; frequency <= 2'b00; // 0-25%
                end
                4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
                    voltage <= 2'b01; frequency <= 2'b01; // 26-50%
                end
                4'b1000, 4'b1001, 4'b1010, 4'b1011: begin
                    voltage <= 2'b10; frequency <= 2'b10; // 51-75%
                end
                default: begin
                    voltage <= 2'b11; frequency <= 2'b11; // 76-100%
                end
            endcase
        end
    end
endmodule