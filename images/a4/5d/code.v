module top_module(
    input clk,
    input in,
    input [1:0] sel,
    output reg out,
    output reg valid
);reg [3:0] delay_reg;

always @(posedge clk) begin
    delay_reg <= {delay_reg[2:0], in};
end

always @(posedge clk) begin
    case(sel)
        2'b00: begin
            valid <= 1'b1;
            out <= delay_reg[3];
        end
        2'b01: begin
            valid <= 1'b0;
            out <= delay_reg[2];
        end
        2'b10: begin
            valid <= 1'b0;
            out <= delay_reg[1];
        end
        2'b11: begin
            valid <= 1'b0;
            out <= delay_reg[0];
        end
    endcase
end

endmodule