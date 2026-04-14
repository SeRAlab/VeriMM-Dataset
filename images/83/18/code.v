module top_module(
    input clk,
    input rst_n,
    input ce,
    input ctrl,
    output reg [3:0] count,
    output reg tc,
    output reg borrow
);reg [3:0] count_reg1, count_reg2;
wire [3:0] count_next;
wire tc_next, borrow_next;

assign count_next = (ctrl == 1'b0) ? (count_reg1 + 4'd1) : (count_reg1 - 4'd1);
assign tc_next = (count_reg1 == 4'hF) ? 1'b1 : 1'b0;
assign borrow_next = (count_reg1 == 4'h0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (rst_n == 1'b0) begin
        count_reg1 <= 4'h0;
        count_reg2 <= 4'h0;
        tc <= 1'b0;
        borrow <= 1'b0;
    end else begin
        if (ce == 1'b1) begin
            count_reg1 <= count_next;
            tc <= tc_next;
            borrow <= borrow_next;
        end
        count_reg2 <= count_reg1;
    end
end

assign count = count_reg2;

endmodule