module twos_complement(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);
    reg calculating;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'd0;
            done <= 1'b0;
            calculating <= 1'b0;
        end else if (start && !calculating) begin
            calculating <= 1'b1;
            done <= 1'b0;
        end else if (calculating) begin
            data_out <= ~data_in + 1;
            calculating <= 1'b0;
            done <= 1'b1;
        end
    end
endmodule