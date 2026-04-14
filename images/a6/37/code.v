module top_module(
    input clk,
    input rst,
    input [31:0] N,
    output reg out
);reg [31:0] counter;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            out <= 0;
        end
        else begin
            if (counter == N-1) begin
                counter <= 0;
                out <= 1;
            end
            else begin
                counter <= counter + 1;
                out <= 0;
            end
        end
    end

endmodule