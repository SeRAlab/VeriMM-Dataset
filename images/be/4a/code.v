module top_module(
    input  wire        clk,
    input  wire        reset,
    input  wire [3:0]  in,
    output reg  [3:0]  out,
    output reg         overflow
);always @(posedge clk) begin
        if (reset) begin
            out <= 4'b0;
            overflow <= 1'b0;
        end else begin
            if (out == 4'hF) begin
                out <= 4'b0;
                overflow <= 1'b1;
            end else begin
                out <= out + 1;
                overflow <= 1'b0;
            end
        end
    end

endmodule