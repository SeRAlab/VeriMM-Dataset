module priority_encoder_4bit
(
    input clk,
    input rst_n,
    input i_en,
    input [3:0] data_in,
    output reg [1:0] result,
    output reg o_valid
);

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        result <= 2'b00;
        o_valid <= 1'b0;
    end else if (i_en) begin
        case (data_in)
            4'b1000: result <= 2'b11;
            4'b0100: result <= 2'b10;
            4'b0010: result <= 2'b01;
            4'b0001: result <= 2'b00;
            default: result <= 2'b00;
        endcase
        o_valid <= (data_in != 4'b0000);
    end else begin
        o_valid <= 1'b0;
    end
end

endmodule