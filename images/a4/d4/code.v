module top_module(
    input [3:0] data_in,
    input clk,
    input rst,
    input en,
    output reg [1:0] data_out
);always @(posedge clk) begin
        if (rst) begin
            data_out <= 2'b00;
        end else if (en) begin
            case (data_in)
                4'b0000: data_out <= 2'b00;
                4'b0001: data_out <= 2'b01;
                4'b0010: data_out <= 2'b01;
                4'b0011: data_out <= 2'b10;
                4'b0100: data_out <= 2'b01;
                4'b0101: data_out <= 2'b10;
                4'b0110: data_out <= 2'b10;
                4'b0111: data_out <= 2'b11;
                4'b1000: data_out <= 2'b01;
                4'b1001: data_out <= 2'b10;
                4'b1010: data_out <= 2'b10;
                4'b1011: data_out <= 2'b11;
                4'b1100: data_out <= 2'b10;
                4'b1101: data_out <= 2'b11;
                4'b1110: data_out <= 2'b11;
                4'b1111: data_out <= 2'b11;
            endcase
        end
    end

endmodule