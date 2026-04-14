module dvfs_controller (
    input wire clk,
    input wire [1:0] workload,
    output reg [1:0] freq_out
);

always @(posedge clk) begin
    case (workload)
        2'b00: freq_out <= 2'b00; // Low frequency
        2'b01: freq_out <= 2'b01; // Medium frequency
        default: freq_out <= 2'b10; // High frequency
    endcase
end

endmodule