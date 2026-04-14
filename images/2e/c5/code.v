module QAM_Modulator (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg signed [15:0] I_out,
    output reg signed [15:0] Q_out
);
    
always @(posedge clk or posedge reset) begin
    if (reset) begin
        I_out <= 0;
        Q_out <= 0;
    end else begin
        case (data_in)
            4'b0000: begin I_out <= 16'h0001; Q_out <= 16'h0001; end // (1, 1)
            4'b0001: begin I_out <= 16'h0001; Q_out <= 16'hFFFF; end // (1, -1)
            4'b0010: begin I_out <= 16'hFFFF; Q_out <= 16'h0001; end // (-1, 1)
            4'b0011: begin I_out <= 16'hFFFF; Q_out <= 16'hFFFF; end // (-1, -1)
            4'b0100: begin I_out <= 16'h0001; Q_out <= 16'h0000; end // (1, 0)
            4'b0101: begin I_out <= 16'h0000; Q_out <= 16'h0001; end // (0, 1)
            4'b0110: begin I_out <= 16'h0000; Q_out <= 16'hFFFF; end // (0, -1)
            4'b0111: begin I_out <= 16'hFFFF; Q_out <= 16'h0000; end // (-1, 0)
            4'b1000: begin I_out <= 16'h0000; Q_out <= 16'h0000; end // (0, 0)
            // Add more mappings as required
            default: begin I_out <= 16'h0000; Q_out <= 16'h0000; end
        endcase
    end
end

endmodule