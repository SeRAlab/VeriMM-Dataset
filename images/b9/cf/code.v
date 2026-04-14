module top_module(
    input clk,
    input d,
    input reset,
    input select,
    input [7:0] in1,
    input [7:0] in2,
    output reg [7:0] out  // Changed from wire to reg
);reg [7:0] q1, q2;
    wire [7:0] sum;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            q1 <= 8'b0;
            q2 <= 8'b0;
        end else begin
            q1 <= d;
            q2 <= q1;
        end
    end

    assign sum = in1 + in2;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            out <= 8'b0;
        end else begin
            if (select) begin
                out <= sum;
            end else begin
                out <= q2;
            end
        end
    end

endmodule