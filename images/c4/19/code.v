module mux_1to2_async_rst(
    input clk,
    input rst,
    input din0,
    input din1,
    input sel,
    output dout
);

    reg dout_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout_reg <= 0;
        end else begin
            if (sel) begin
                dout_reg <= din1;
            end else begin
                dout_reg <= din0;
            end
        end
    end

    assign dout = dout_reg;

endmodule