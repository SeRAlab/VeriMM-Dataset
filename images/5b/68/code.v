module top_module(
    input wire clk, 
    input wire rst,

    input wire [8:0] x_i,
    input wire [6:0] y_i,
    input wire pop_i,
    output wire [5:0] r_o,
    output wire [5:0] g_o,
    output wire [5:0] b_o,
    output wire ack_o);reg [5:0] r_ff;
reg [5:0] g_ff;
reg [5:0] b_ff;
reg ack_ff;

always @(posedge clk) begin
    if (rst) begin
        r_ff <= 6'h00;
        g_ff <= 6'h00;
        b_ff <= 6'h00;
        ack_ff <= 1'b0;
    end else if (pop_i) begin
        if (y_i == 7'd1)
            r_ff <= 6'h3f;
        else
            r_ff <= 6'h00;

        if (y_i == 7'd0)
            g_ff <= 6'h3f;
        else
            g_ff <= 6'h00;

        if (y_i == 7'd95)
            b_ff <= 6'h3f;
        else
            b_ff <= 6'h00;

        ack_ff <= 1'b1;
    end else
        ack_ff <= 1'b0;
end

assign r_o = r_ff;
assign g_o = g_ff;
assign b_o = b_ff;
assign ack_o = ack_ff;

endmodule