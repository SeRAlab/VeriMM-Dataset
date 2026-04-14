module top_module(
    input clk,
    input rst_n,
    input a,
    output reg out_comb_always,
    output reg rise,
    output reg down,
    output reg final_output
);reg a_d1;
reg a_d2;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        a_d1 <= 1'b0;
        a_d2 <= 1'b0;
    end else begin
        a_d1 <= a;
        a_d2 <= a_d1;
    end
end

assign out_comb_always = a ^ a_d1;

assign rise = (a_d1 ^ a_d2) & a_d1;
assign down = (a_d1 ^ a_d2) & ~a_d1;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        final_output <= 1'b0;
    end else begin
        if(rise) begin
            final_output <= out_comb_always;
        end else if(down) begin
            final_output <= ~out_comb_always;
        end
    end
end

endmodule