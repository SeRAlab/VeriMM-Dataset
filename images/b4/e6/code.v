module top_module(
    input CLK,
    input UP_DOWN,
    input RESET,
    output reg [3:0] OUT
);always @(posedge CLK) begin
        if (RESET) begin
            OUT <= 4'b0000;
        end
        else if (UP_DOWN) begin
            OUT <= OUT + 1;
        end
        else begin
            OUT <= OUT - 1;
        end
    end

endmodule