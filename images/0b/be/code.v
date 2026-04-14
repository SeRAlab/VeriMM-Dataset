module dvfs_controller(
    input clk,
    input reset,
    input [1:0] load,
    output reg [3:0] frequency,
    output reg [3:0] voltage
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 4'b0000; // Default frequency
            voltage <= 4'b0000;    // Default voltage
        end else begin
            case (load)
                2'b00: begin
                    frequency <= 4'b0010; // Low load frequency
                    voltage <= 4'b0010;   // Low load voltage
                end
                2'b01: begin
                    frequency <= 4'b0100; // Medium load frequency
                    voltage <= 4'b0100;   // Medium load voltage
                end
                2'b10: begin
                    frequency <= 4'b1000; // High load frequency
                    voltage <= 4'b1000;   // High load voltage
                end
                default: begin
                    frequency <= 4'b0000; // Default case
                    voltage <= 4'b0000;    // Default case
                end
            endcase
        end
    end
endmodule