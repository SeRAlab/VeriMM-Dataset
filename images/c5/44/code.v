module counter (
    input clk,
    input n_rst,
    input up,
    input dn,
    input in1,
    input in2,
    output reg [31:0] cnt,
    output reg [3:0] cnt_1k,
    output reg out1,
    output reg out2
);

always @(posedge clk) begin
    if (n_rst) begin
        cnt <= 0;
        cnt_1k <= 0;
    end else if (up && !dn) begin
        cnt <= cnt + 1;
    end else if (!up && dn) begin
        cnt <= cnt - 1;
    end
end

always @(posedge clk) begin
    if (cnt >= 1000) begin
        cnt_1k <= cnt_1k + 1;
        cnt <= cnt - 1000;
    end
end

endmodule