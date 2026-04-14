module rnn_cell (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] input_data,
    output reg [3:0] output_data
);
    reg [3:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 4'b0000;
            output_data <= 4'b0000;
        end else if (enable) begin
            state <= (state + input_data) % 16;
            output_data <= state;
        end
    end
endmodule