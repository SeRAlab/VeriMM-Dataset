module dvfs_controller(
    input clk,
    input reset,
    input [1:0] request,
    output reg [3:0] frequency,  // 4-bit representation of frequency
    output reg [3:0] voltage      // 4-bit representation of voltage
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 4'b0000; // Default frequency
            voltage <= 4'b0000;   // Default voltage
        end else begin
            case (request)
                2'b00: begin
                    frequency <= 4'b0001; // 1 GHz
                    voltage <= 4'b0001;   // 1.0 V
                end
                2'b01: begin
                    frequency <= 4'b0010; // 2 GHz
                    voltage <= 4'b0010;   // 1.2 V
                end
                2'b10: begin
                    frequency <= 4'b0011; // 3 GHz
                    voltage <= 4'b0011;   // 1.4 V
                end
                2'b11: begin
                    frequency <= 4'b0100; // 4 GHz
                    voltage <= 4'b0110;   // 1.6 V
                end
                default: begin
                    frequency <= 4'b0000;
                    voltage <= 4'b0000;
                end
            endcase
        end
    end
endmodule