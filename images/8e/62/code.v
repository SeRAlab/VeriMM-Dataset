module top_module(
    input clk,
    input load,
    input ena,
    input clr,
    input [7:0] data,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (clr) begin
            q <= 8'b00000000;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            q <= q >>> 1;  // Arithmetic shift right by 1 bit
        end
    end

endmodule