module dvfs_controller (
    input wire clk,
    input wire [1:0] workload,
    output reg [3:0] freq_out,
    output reg [3:0] volt_out
);
    always @(posedge clk) begin
        case (workload)
            2'b00: begin
                freq_out <= 4'b0001; // 1 GHz
                volt_out <= 4'b0001; // 1.0 V
            end
            2'b01: begin
                freq_out <= 4'b0011; // 1.5 GHz
                volt_out <= 4'b0010; // 1.2 V
            end
            2'b10: begin
                freq_out <= 4'b0100; // 2.0 GHz
                volt_out <= 4'b0011; // 1.4 V
            end
            2'b11: begin
                freq_out <= 4'b0101; // 2.5 GHz
                volt_out <= 4'b0100; // 1.6 V
            end
            default: begin
                freq_out <= 4'b0000; // Default case
                volt_out <= 4'b0000; // Default case
            end
        endcase
    end
endmodule