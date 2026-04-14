module sign_extend(
    input [15:0] reg_in,
    output reg [31:0] reg_out,
    input clk,
    input reset
);

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            reg_out <= 0;
        end
        else begin
            if (reg_in[15] == 1) begin
                reg_out <= {16'b1111111111111111, reg_in};
            end
            else begin
                reg_out <= {16'b0000000000000000, reg_in};
            end
        end
    end

endmodule