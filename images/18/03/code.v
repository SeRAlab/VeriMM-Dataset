module ofdm_modulator (
    input wire clk,
    input wire rst_n,
    input wire [1:0] data_in,
    output reg signed [15:0] i_out,
    output reg signed [15:0] q_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_out <= 0;
            q_out <= 0;
        end else begin
            case (data_in)
                2'b00: begin
                    i_out <= 16'h7FFF; // π/4 phase
                    q_out <= 16'h0000; // 0 phase
                end
                2'b01: begin
                    i_out <= 16'h7FFF; // π/4 phase
                    q_out <= 16'h7FFF; // π/2 phase
                end
                2'b10: begin
                    i_out <= 16'h0000; // 0 phase
                    q_out <= 16'h7FFF; // π phase
                end
                2'b11: begin
                    i_out <= 16'hFFFF; // -π/4 phase
                    q_out <= 16'h7FFF; // 3π/2 phase
                end
                default: begin
                    i_out <= 0;
                    q_out <= 0;
                end
            endcase
        end
    end
endmodule