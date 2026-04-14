module top_module(input clk, input reset, input [3:0] bin_in, output [3:0] gray_out);reg [3:0] gray_out_reg;

    always @(posedge clk) begin
        if (reset)
            gray_out_reg <= 4'b0000;
        else begin
            gray_out_reg[3] <= bin_in[3];
            gray_out_reg[2] <= bin_in[3] ^ bin_in[2];
            gray_out_reg[1] <= bin_in[2] ^ bin_in[1];
            gray_out_reg[0] <= bin_in[1] ^ bin_in[0];
        end
    end

    assign gray_out = gray_out_reg;

endmodule