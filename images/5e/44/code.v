module top_module(
    input clk,
    input load,
    input ena,
    input direction,
    input [7:0] data,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            if (direction) begin
                q <= q >> 1;
            end else begin
                q <= q << 1;
            end
        end
    end

endmodule