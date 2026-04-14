module top_module(
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0] data_in,
    output reg [3:0] count,
    output reg carry_out
);reg [3:0] count_reg1;
reg [3:0] count_reg2;

always @(posedge clk) begin
    if (reset) begin
        count_reg1 <= 4'b0;
        count_reg2 <= 4'b0;
        carry_out <= 1'b0;
    end
    else if (enable) begin
        if (load) begin
            count_reg1 <= data_in;
            count_reg2 <= data_in;
            carry_out <= 1'b0;
        end
        else begin
            count_reg1 <= count_reg2 + 4'b1;
            count_reg2 <= count_reg1;
            if (count_reg1 == 4'b1111) begin
                carry_out <= 1'b1;
            end
            else begin
                carry_out <= 1'b0;
            end
        end
    end
end

assign count = count_reg1;

endmodule