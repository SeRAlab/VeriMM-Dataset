module top_module(
    input clk,
    input rst,
    input start,
    input [31:0] src_addr,
    input [31:0] dest_addr,
    input [9:0] length,
    output busy,
    output error,
    output done
);reg [31:0] src_reg;
reg [31:0] dest_reg;
reg [9:0] length_reg;
reg [31:0] count_reg;
reg busy_reg;
reg error_reg;
reg done_reg;

always @(posedge clk) begin
    if (rst) begin
        src_reg <= 0;
        dest_reg <= 0;
        length_reg <= 0;
        count_reg <= 0;
        busy_reg <= 0;
        error_reg <= 0;
        done_reg <= 0;
    end else begin
        if (start) begin
            src_reg <= src_addr;
            dest_reg <= dest_addr;
            length_reg <= length;
            count_reg <= 0;
            busy_reg <= 1;
            error_reg <= 0;
            done_reg <= 0;
        end else if (busy_reg) begin
            if (count_reg == length_reg - 1) begin
                busy_reg <= 0;
                done_reg <= 1;
            end else begin
                count_reg <= count_reg + 1;
                src_reg <= src_reg + 4;
                dest_reg <= dest_reg + 4;
            end
        end
    end
end

assign busy = busy_reg;
assign error = error_reg;
assign done = done_reg;

endmodule