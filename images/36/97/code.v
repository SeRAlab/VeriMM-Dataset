module rnn_cell (
    input clk,
    input reset,
    input [3:0] input_data,
    output reg [3:0] output_data
);
    reg [3:0] prev_output;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_output <= 4'b0000;
            output_data <= 4'b0000;
        end else begin
            output_data <= (prev_output + input_data) % 16;
            prev_output <= output_data;
        end
    end
endmodule