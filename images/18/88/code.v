module QAM_Transmitter (
    input clk,
    input rst,
    input enable,
    input [3:0] data_in,
    output reg [1:0] I_out,
    output reg [1:0] Q_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            I_out <= 2'b00;
            Q_out <= 2'b00;
        end else if (enable) begin
            case (data_in)
                4'b0000: begin I_out <= 2'b01; Q_out <= 2'b01; end // (1, 1)
                4'b0001: begin I_out <= 2'b01; Q_out <= 2'b10; end // (1, -1)
                4'b0010: begin I_out <= 2'b10; Q_out <= 2'b01; end // (-1, 1)
                4'b0011: begin I_out <= 2'b10; Q_out <= 2'b10; end // (-1, -1)
                // additional mappings can be defined here for 16-QAM
                default: begin I_out <= 2'b00; Q_out <= 2'b00; end
            endcase
        end
    end
endmodule