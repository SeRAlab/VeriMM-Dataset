module top_module(
    input clk,              // Added the clk input here
    input [3:0] in,
    output reg [1:0] pos,
    output reg zero_flag
);reg [3:0] in_reg;
reg [1:0] pos_reg;

always @(posedge clk) begin
    in_reg <= in;
    pos_reg <= pos_reg;
end

always @(posedge clk) begin
    if (in_reg == 0) begin
        pos_reg <= 2'b00;
        zero_flag <= 1'b1;
    end else begin
        zero_flag <= 1'b0;
        case (in_reg)
            4'b1000: pos_reg <= 2'b11;
            4'b0100: pos_reg <= 2'b10;
            4'b0010: pos_reg <= 2'b01;
            4'b0001: pos_reg <= 2'b00;
            default: pos_reg <= pos_reg;
        endcase
    end
end

assign pos = pos_reg;

endmodule