module top_module(
    input d,
    input clk,
    input clr,
    input pr,
    input en,
    input sel,
    input in0,
    input in1,
    output q,
    output out
);reg q_reg;
wire mux_out;

assign out = mux_out;

always @ (posedge clk) begin
    if (clr) begin
        q_reg <= 0;
    end else if (pr) begin
        q_reg <= 1;
    end else if (en) begin
        q_reg <= d;
    end
end

assign mux_out = sel ? in1 : in0;

assign q = q_reg;

endmodule