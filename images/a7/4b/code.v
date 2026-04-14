module top_module(
    input clk,
    input reset,
    input [31:0] modulus,
    input [7:0] duty_cycle,
    output reg out_clk
);reg [31:0] count;
    reg [7:0] threshold;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            threshold <= (modulus * duty_cycle) / 256;
            out_clk <= 0;
        end else begin
            count <= count + 1;
            if (count >= modulus) begin
                count <= 0;
                out_clk <= 0;
            end else if (count >= threshold) begin
                out_clk <= 1;
            end
        end
    end

endmodule