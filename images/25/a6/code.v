module QAM_Modulator (
    input wire clk,
    input wire rst,
    input wire I,
    input wire Q,
    output reg [1:0] QAM_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        QAM_out <= 2'b00;
    end else begin
        case ({I, Q})
            2'b00: QAM_out <= 2'b00;
            2'b01: QAM_out <= 2'b01;
            2'b10: QAM_out <= 2'b10;
            2'b11: QAM_out <= 2'b11;
            default: QAM_out <= 2'b00; // Default case
        endcase
    end
end

endmodule