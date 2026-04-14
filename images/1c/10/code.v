module dvfs_controller (
    input wire clk,
    input wire [1:0] control,
    output reg [3:0] voltage,
    output reg [3:0] frequency
);

always @(posedge clk) begin
    case (control)
        2'b00: begin // Low performance
            voltage <= 4'b0001; // 1V
            frequency <= 4'b0010; // 2GHz
        end
        2'b01: begin // Medium performance
            voltage <= 4'b0010; // 2V
            frequency <= 4'b0100; // 4GHz
        end
        2'b10: begin // High performance
            voltage <= 4'b0011; // 3V
            frequency <= 4'b1000; // 8GHz
        end
        default: begin
            voltage <= 4'b0000; // Default case
            frequency <= 4'b0000;
        end
    endcase
end

endmodule