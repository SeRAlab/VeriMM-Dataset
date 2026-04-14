module DVFS_Controller (
    input wire clk,
    input wire reset,
    input wire [1:0] workload,
    output reg [7:0] Vout,
    output reg [7:0] Fout
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Vout <= 8'b00000001; // 1.0V
            Fout <= 8'b00000001; // 1.0GHz
        end else begin
            case (workload)
                2'b00: begin
                    Vout <= 8'b00000001; // 1.0V
                    Fout <= 8'b00000001; // 1.0GHz
                end
                2'b01: begin
                    Vout <= 8'b00000010; // 1.2V
                    Fout <= 8'b00000010; // 1.2GHz
                end
                2'b10: begin
                    Vout <= 8'b00000101; // 1.5V
                    Fout <= 8'b00000101; // 1.5GHz
                end
                2'b11: begin
                    Vout <= 8'b00011000; // 1.8V
                    Fout <= 8'b00011000; // 1.8GHz
                end
                default: begin
                    Vout <= 8'b00000001; // Default to 1.0V
                    Fout <= 8'b00000001; // Default to 1.0GHz
                end
            endcase
        end
    end
endmodule