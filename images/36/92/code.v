module DVFS_Controller(
    input [1:0] load,
    input clk,
    input rst,
    output reg [1:0] frequency, // 00: 1MHz, 01: 2MHz, 10: 4MHz
    output reg [1:0] voltage    // 00: 1V, 01: 1.5V, 10: 2V
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            frequency <= 2'b00; // Default to 1 MHz
            voltage <= 2'b00;   // Default to 1V
        end else begin
            case (load)
                2'b00: begin
                    frequency <= 2'b00; // 1 MHz
                    voltage <= 2'b00;   // 1V
                end
                2'b01: begin
                    frequency <= 2'b01; // 2 MHz
                    voltage <= 2'b01;   // 1.5V
                end
                2'b10: begin
                    frequency <= 2'b10; // 4 MHz
                    voltage <= 2'b10;   // 2V
                end
                2'b11: begin
                    // Hold last state
                    frequency <= frequency;
                    voltage <= voltage;
                end
            endcase
        end
    end
endmodule