module top_module(
    input clk,
    input [7:0] in,
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output reg out_func
);reg [7:0] prev_in;
reg edge_detected;

always @(posedge clk) begin
    if (in != prev_in) begin
        edge_detected <= 1;
    end else begin
        edge_detected <= 0;
    end
    prev_in <= in;
end

always @(*) begin
    if (edge_detected) begin
        if (sel_b1) begin
            out_func <= a;
        end else begin
            out_func <= b;
        end
    end else begin
        if (sel_b2) begin
            out_func <= a;
        end else begin
            out_func <= b;
        end
    end
end

endmodule