module QAM_Encoder (
    input wire clk,
    input wire [1:0] data_in,
    output reg [3:0] I_out,
    output reg [3:0] Q_out
);
    always @(posedge clk) begin
        case(data_in)
            2'b00: begin
                I_out <= 4'b0001; // 1
                Q_out <= 4'b0001; // 1
            end
            2'b01: begin
                I_out <= 4'b0001; // 1
                Q_out <= 4'b1111; // -1
            end
            2'b10: begin
                I_out <= 4'b1111; // -1
                Q_out <= 4'b0001; // 1
            end
            2'b11: begin
                I_out <= 4'b1111; // -1
                Q_out <= 4'b1111; // -1
            end
            default: begin
                I_out <= 4'b0000; // Default case
                Q_out <= 4'b0000; // Default case
            end
        endcase
    end
endmodule