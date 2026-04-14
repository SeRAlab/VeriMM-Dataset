module top_module(
    input clk,
    input up_down,
    input load,
    input en,
    input [3:0] data_in,
    output reg [3:0] out
);always @(posedge clk) begin
        if (en) begin
            if (load) begin
                out <= data_in;
            end else begin
                if (up_down) begin
                    out <= out + 1;
                end else begin
                    out <= out - 1;
                end
            end
        end
    end

endmodule