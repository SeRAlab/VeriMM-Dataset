module top_module(
    input clk,
    input load,
    input up_down,
    output reg [2:0] out
);always @(posedge clk) begin
        if (load) begin
            out <= $random;
        end
        else if (up_down) begin
            out <= out + 1;
        end
        else begin
            out <= out - 1;
        end
    end

endmodule