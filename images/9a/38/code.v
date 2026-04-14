module top_module(
    input clk,
    input reset,
    input [7:0] in_data,
    input in_valid,
    output reg in_ready,
    output reg [7:0] out_data,
    output reg out_valid,
    input out_ready,
    output reg out_error
);reg [3:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            in_ready <= 0;
            out_valid <= 0;
            out_data <= 0;
            out_error <= 0;
            counter <= 0;
        end else begin
            if (in_valid && !out_valid && out_ready) begin
                in_ready <= 1;
                out_valid <= 1;
                out_data <= in_data;
                counter <= 0;
            end else if (out_ready && out_valid) begin
                in_ready <= 0;
                out_valid <= 0;
                counter <= 0;
            end else if (counter < 10) begin
                counter <= counter + 1;
            end else begin
                in_ready <= 0;
                out_valid <= 0;
                out_error <= 1;
                counter <= 0;
            end
        end
    end

endmodule