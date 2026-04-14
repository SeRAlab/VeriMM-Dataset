module dvfs_controller (
    input wire clk,
    input wire reset,
    input wire [2:0] load,
    output reg [1:0] frequency,
    output reg [1:0] voltage
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frequency <= 2'b00; // low frequency
            voltage <= 2'b00; // low voltage
        end else begin
            case (load)
                3'b000: begin // low load
                    frequency <= 2'b00; // low frequency
                    voltage <= 2'b00; // low voltage
                end
                3'b001: begin // low-medium load
                    frequency <= 2'b01; // medium frequency
                    voltage <= 2'b00; // low voltage
                end
                3'b010: begin // medium load
                    frequency <= 2'b01; // medium frequency
                    voltage <= 2'b01; // medium voltage
                end
                3'b011: begin // medium-high load
                    frequency <= 2'b10; // high frequency
                    voltage <= 2'b01; // medium voltage
                end
                3'b100: begin // high load
                    frequency <= 2'b10; // high frequency
                    voltage <= 2'b10; // high voltage
                end
                3'b101: begin // high load
                    frequency <= 2'b10; // high frequency
                    voltage <= 2'b10; // high voltage
                end
                3'b110: begin // high load
                    frequency <= 2'b10; // high frequency
                    voltage <= 2'b10; // high voltage
                end
                3'b111: begin // max load
                    frequency <= 2'b10; // high frequency
                    voltage <= 2'b10; // high voltage
                end
                default: begin
                    frequency <= 2'b00; // low frequency
                    voltage <= 2'b00; // low voltage
                end
            endcase
        end
    end
endmodule