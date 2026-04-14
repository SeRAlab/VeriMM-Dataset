module dvfs_controller (
    input wire clk,
    input wire enable,
    input wire [1:0] workload,
    output reg [1:0] voltage,
    output reg [1:0] frequency
);
    
    always @(posedge clk) begin
        if (enable) begin
            case (workload)
                2'b00: begin
                    voltage <= 2'b00; // 0.8V
                    frequency <= 2'b00; // 1x
                end
                2'b01: begin
                    voltage <= 2'b01; // 1.0V
                    frequency <= 2'b01; // 2x
                end
                2'b10: begin
                    voltage <= 2'b10; // 1.2V
                    frequency <= 2'b10; // 4x
                end
                2'b11: begin
                    voltage <= 2'b10; // 1.2V
                    frequency <= 2'b10; // 4x
                end
                default: begin
                    voltage <= voltage; // Hold previous state
                    frequency <= frequency; // Hold previous state
                end
            endcase
        end
    end
endmodule