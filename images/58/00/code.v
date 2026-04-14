module top_module(
    input clk,
    input rst,
    input in_sign_a,
    input in_sign_b,
    output out_sign
);reg sign_reg;
    reg out;
    reg sign_a_local;       
    reg sign_b_local;
    always @ (posedge clk)
    begin
        sign_a_local  <= in_sign_a;
        sign_b_local <= in_sign_b;
    end
    always @ (posedge clk)
    begin
        if(rst)
            sign_reg <= 0;
        else
            sign_reg <= sign_a_local ^ sign_b_local;
    end
    always @ (posedge clk)
    begin
        if(rst)
            out <= 0;
        else
            out <= sign_reg;
    end
    assign out_sign = out;endmodule