module top_module(
    input clk,
    input [7:0] d,
    input sel,
    output [7:0] q
);reg [7:0] q_int;
reg [3:0] dff_sel;

always @(negedge clk) begin
    q_int <= {q_int[6:0], d[0]};
    dff_sel <= sel ? dff_sel + 1 : dff_sel - 1;
end

assign q = (dff_sel[3]) ? {q_int[7:4], q_int[3:0]} : {q_int[3:0], q_int[7:4]};

endmodule