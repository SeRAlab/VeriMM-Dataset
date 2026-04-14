module top_module(
    input clk, n_rst, up, dn,
    output [3:0] cnt,
    output out1, out2
);reg [3:0] cnt_reg;
    reg [3:0] cnt_next;  // Changed from wire to reg for cnt_next

    assign out1 = ~cnt_reg[0];
    assign out2 = cnt_reg[0];

    always @ (posedge clk, negedge n_rst) begin
        if (~n_rst) begin
            cnt_reg <= 4'b0;
        end else begin
            cnt_reg <= cnt_next;
        end
    end

    always @ (*) begin
        if (up && !dn && cnt_reg < 4'hf) begin
            cnt_next = cnt_reg + 1;
        end else if (dn && !up && cnt_reg > 4'b0) begin
            cnt_next = cnt_reg - 1;
        end else begin
            cnt_next = cnt_reg;
        end
    end

    assign cnt = cnt_reg;

endmodule