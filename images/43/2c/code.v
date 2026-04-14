module shift_register (
    input clk,
    input rst,
    input en,
    input dir,
    input [2:0] in_data,
    output reg [2:0] shift_reg);

    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 3'b0;
        end else if (en) begin
            if (dir) begin
                shift_reg <= {shift_reg[1:0], in_data[2]};
            end else begin
                shift_reg <= {in_data[0], shift_reg[2:1]};
            end
        end
    end
endmodule