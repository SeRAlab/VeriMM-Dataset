module dvfs_controller (
    input wire [1:0] workload,
    input wire [2:0] temperature,
    output reg [1:0] frequency,  // 00: low, 01: medium, 10: high
    output reg [1:0] voltage      // 00: low, 01: medium, 10: high
);
    
    always @(workload or temperature) begin
        case (workload)
            2'b00: begin // low workload
                frequency <= 2'b00; // low frequency
                voltage <= (temperature == 3'b000) ? 2'b00 : // low temp
                           (temperature == 3'b001) ? 2'b01 : // medium temp
                           2'b10; // high temp
            end
            2'b01: begin // medium workload
                frequency <= 2'b01; // medium frequency
                voltage <= (temperature == 3'b000) ? 2'b01 : // low temp
                           (temperature == 3'b001) ? 2'b01 : // medium temp
                           2'b10; // high temp
            end
            2'b10: begin // high workload
                frequency <= 2'b10; // high frequency
                voltage <= (temperature == 3'b000) ? 2'b10 : // low temp
                           (temperature == 3'b001) ? 2'b10 : // medium temp
                           2'b10; // high temp
            end
            default: begin
                frequency <= 2'b00; // default to low frequency
                voltage <= 2'b00; // default to low voltage
            end
        endcase
    end
endmodule