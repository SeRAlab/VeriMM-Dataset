module ofdm_modulator (
    input clk,
    input rst,
    input [1:0] data_in,
    output reg [7:0] I_out,
    output reg [7:0] Q_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            I_out <= 8'b0;
            Q_out <= 8'b0;
        end else begin
            case (data_in)
                2'b00: begin
                    I_out <= 8'hFF; // 1
                    Q_out <= 8'h00; // 0
                end
                2'b01: begin
                    I_out <= 8'h00; // 0
                    Q_out <= 8'hFF; // 1
                end
                2'b10: begin
                    I_out <= 8'hFF; // -1
                    Q_out <= 8'hFF; // 1
                end
                2'b11: begin
                    I_out <= 8'hFF; // 0
                    Q_out <= 8'h00; // -1
                end
                default: begin
                    I_out <= 8'b0;
                    Q_out <= 8'b0;
                end
            endcase
        end
    end
endmodule