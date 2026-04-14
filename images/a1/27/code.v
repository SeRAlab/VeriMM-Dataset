module top_module(
    input clk,
    input rst_n,
    input ce,
    input load,
    input ctrl,
    input [3:0] preset,
    input [3:0] compare_val,
    output reg [3:0] count,
    output tc,
    output comp
);reg [3:0] count_reg;
reg [3:0] count_next;
reg tc_reg;
reg comp_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count_reg <= 4'b0;
        tc_reg <= 1'b0;
        comp_reg <= 1'b0;
    end
    else begin
        if (ce) begin
            count_reg <= count_next;
            tc_reg <= (count_next == 4'b1111 && ctrl) || (count_next == 4'b0000 && ~ctrl);
            comp_reg <= (count_next == compare_val);
        end
    end
end

always @* begin
    count_next = count_reg;
    if (load) begin
        count_next = preset;
    end
    else begin
        if (ctrl) begin
            count_next = (count_reg == 4'b1111) ? 4'b0000 : count_reg + 1;
        end
        else begin
            count_next = (count_reg == 4'b0000) ? 4'b1111 : count_reg - 1;
        end
    end
end

assign count = count_reg;
assign tc = tc_reg;
assign comp = comp_reg;

endmodule