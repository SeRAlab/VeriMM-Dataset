module top_module(
    input clk,
    input load,
    input ena,
    input clr,
    input [3:0] data,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (clr) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            q <= q << 1;  // Shift left by 1 bit
        end
    end

endmodule